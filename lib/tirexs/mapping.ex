defmodule Tirexs.Mapping do
  @moduledoc false


  use Tirexs.DSL.Logic

  @doc false
  defmacro __using__(_) do
    quote do
      import unquote(Tirexs.Index.Settings), only: :macros
      import unquote(__MODULE__), only: :macros
    end
  end

  @doc false
  defmacro mappings([do: block]) do
    mappings =  [properties: extract(block)]
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
          Dict.put([], to_atom(name), options ++ [properties: extract(block[:do])])
        else
          Dict.put([], to_atom(name), options)
        end
      [name, options, block] ->
        Dict.put([], to_atom(name), options ++ [properties: extract(block[:do])])
    end
  end

  @doc false
  def create_resource(definition, uri \\ Tirexs.get_uri_env()) do
    cond do
      definition[:settings] ->
        path = "#{definition[:index]}"
        body = to_resource_json(definition)

        HTTP.post(path, uri, body)
      definition[:type] ->
        create_resource_settings(definition, uri)

        path = "#{definition[:index]}/#{definition[:type]}/_mapping"
        body = to_resource_json(definition)

        HTTP.put(path, uri, body)
      true ->
        path = "#{definition[:index]}/_mapping"
        body = to_resource_json(definition, definition[:index])

        HTTP.put(path, uri, body)
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
    resource =
      # definition w/ mappings and settings
      if definition[:settings] != nil do
        mappings_dict = Dict.put([], to_atom(type), definition[:mapping])
        resource = Dict.put([], to_atom("mappings"), mappings_dict)
        resource = Dict.put(resource, to_atom("settings"), definition[:settings])
      # definition just only w/ mapping
      else
        Dict.put([], to_atom(type), definition[:mapping])
      end

    HTTP.encode(resource)
  end
end
