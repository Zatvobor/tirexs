defmodule Tirexs.ElasticSearch.Settings do
  @moduledoc false

  alias Tirexs.{Resources, HTTP}


  @doc false
  def create_resource(definition, uri \\ Tirexs.get_uri_env()) do
    if Resources.exists?(definition[:index], uri) do
      HTTP.delete(definition[:index], uri)
    end
    HTTP.put(definition[:index], uri, to_resource_json(definition))
  end

  @doc false
  def to_resource_json(definition) do
    HTTP.encode([settings: definition[:settings]])
  end
end
