defmodule Tirexs.Mapping do
  @moduledoc """
  Provides DSL-like macros for indices definition.

  The mapping could be defined alongside with `settings` or just only `mappings`.

  Mappings and Settings definition:

      index = [index: "articles", type: "article"]

      settings do
        analysis do
          analyzer "autocomplete_analyzer",
          [
            filter: ["lowercase", "asciifolding", "edge_ngram"],
            tokenizer: "whitespace"
          ]
          filter "edge_ngram", [type: "edgeNGram", min_gram: 1, max_gram: 15]
        end
      end

      mappings dynamic: false do
        indexes "country", type: "string"
        indexes "city", type: "string"
        indexes "suburb", type: "string"
        indexes "road", type: "string"
        indexes "postcode", type: "string", index: "not_analyzed"
        indexes "housenumber", type: "string", index: "not_analyzed"
        indexes "coordinates", type: "geo_point"
        indexes "full_address", type: "string", analyzer: "autocomplete_analyzer"
      end

      Tirexs.Mapping.create_resource(index)

  """


  use Tirexs.DSL.Logic

  @doc false
  defmacro __using__(_) do
    quote do
      import unquote(Tirexs.Index.Settings), only: :macros
      import unquote(__MODULE__), only: :macros
    end
  end

  @doc false
  defmacro mappings(params, [do: block]) do
    mappings = Keyword.merge(params, [properties: extract(block)])
    quote_mappings(mappings)
  end

  @doc false
  defmacro mappings([do: block]) do
    mappings =  [properties: extract(block)]
    quote_mappings(mappings)
  end

  defp quote_mappings(mappings) do
    quote do
      var!(index) = var!(index) ++ [mapping: unquote(mappings)]
    end
  end

  alias Tirexs.{Resources, HTTP}

  @doc false
  def transpose(block) do
    case block do
      {:indexes, _, [params]} -> indexes(params[:do])
      {:indexes, _, options}  -> indexes(options)
      {:index, _, [params]}   -> indexes(params[:do])
      {:index, _, options}    -> indexes(options)
    end
  end

  @doc false
  def indexes(options) do
    case options do
      [name, options] ->
        if options[:do] != nil do
          block = options
          options = [type: "object"]
          [ {to_atom(name), options ++ [properties: extract(block[:do])]} ]
        else
          [ {to_atom(name), options} ]
        end
      [name, options, block] ->
        [ {to_atom(name), options ++ [properties: extract(block[:do])]} ]
    end
  end

  @doc false
  def create_resource(definition, uri \\ Tirexs.get_uri_env()) do
    cond do
      definition[:settings] ->
        body = to_resource_json(definition)
        HTTP.post("#{definition[:index]}", uri, body)
      definition[:type] ->
        create_resource_settings(definition, uri)
        body = to_resource_json(definition)
        Resources.bump!(body, uri)._mapping(definition[:index], definition[:type])
      true ->
        body = to_resource_json(definition, definition[:index])
        Resources.bump!(body, uri)._mapping(definition[:index])
    end
  end

  @doc false
  def create_resource_settings(definition, uri \\ Tirexs.get_uri_env()) do
    unless Resources.exists?(definition[:index], uri) do
      HTTP.put(definition[:index], uri)
    end
  end

  @doc false
  def to_resource_json(definition) do
    to_resource_json(definition, definition[:type])
  end

  @doc false
  def to_resource_json(definition, type) do
    # definition w/ mappings and settings
    if definition[:settings] != nil do
      [ {:mappings, [{to_atom(type), definition[:mapping]}]}, {:settings, definition[:settings]} ]
    # definition just only w/ mapping
    else
      [ {to_atom(type), definition[:mapping]} ]
    end
  end
end
