require Tirexs.ElasticSearch

defmodule Tirexs.River do
  @moduledoc false

  import Tirexs.ElasticSearch
  require Tirexs.ElasticSearch

  @doc false
  defmacro __using__(_) do
    quote do
      import unquote(Tirexs.River), only: [river: 2, index: 1, init_river: 1]
      import unquote(Tirexs.River.Couchdb)
    end
  end

  @doc false
  defmacro river(options, [do: block]) do
    quote do
      var!(river) = var!(river) ++ [river: true] ++ unquote(options)
      unquote(block)
    end
  end

  @doc false
  defmacro index([do: block]) do
    quote do
      var!(river) = var!(river) ++ [index: unquote(block)]
    end
  end

  @doc false
  def init_river(settings), do: settings

  @doc false
  def create_resource(definition) do
    create_resource(definition, Tirexs.ElasticSearch.config())
  end

  @doc false
  def create_resource(definition, opts) do
    url = "_river/#{definition[:name]}"
    if exist?(url, opts), do: delete(url, opts)

    url  = "#{url}/_meta"
    json = to_resource_json(definition)
    Tirexs.ElasticSearch.put(url, json, opts)
  end

  @doc false
  def to_resource_json(definition) do
    definition = Dict.delete(Dict.delete(definition, :name), :river)
    JSX.encode!(definition)
  end
end
