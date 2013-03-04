defmodule Tirexs.ElasticSearch.Settings do
  @moduledoc false

  import Tirexs.ElasticSearch

  @doc false
  def create_resource(definition, opts) do
    if exist?(definition[:name], opts), do: delete(definition[:name], opts)
    post(definition[:name], to_resource_json(definition), opts)
  end

  @doc false
  def to_resource_json(definition) do
    JSON.encode [settings: definition[:settings]]
  end
end