defmodule Tirexs.ElasticSearch.Settings do
  @moduledoc false

  import Tirexs.ElasticSearch

  @doc false
  def create_resource(definition) do
    create_resource(definition, record_config())
  end

  @doc false
  def create_resource(definition, opts) do
    if exist?(definition[:index], opts), do: delete(definition[:index], opts)
    post(definition[:index], to_resource_json(definition), opts)
  end

  @doc false
  def to_resource_json(definition) do
    JSEX.encode! [settings: definition[:settings]]
  end
end