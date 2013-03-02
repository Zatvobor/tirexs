defmodule Tirexs.ElasticSearch.Settings do
  @moduledoc false

  import Tirexs.ElasticSearch

  @doc false
  def create_resource(definition, opts) do
    if exist?(opts[:name], opts), do: delete(opts[:name], opts)
    post(opts[:name], to_resource_json(definition), opts)
  end


  defp to_resource_json(definition) do
    JSON.encode [settings: definition[:settings]]
  end
end