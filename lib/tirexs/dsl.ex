defmodule Tirexs.DSL do
  @moduledoc """
  This module represents a main entry point for defining DSL scenarios.
  Check an `examples` directory which consists a DSL tempaltes for `mapping`, `settings`, `query` and `river`.
  """

  @doc false
  def define(type, resource) do
    elastic_settings = Tirexs.ElasticSearch.Config.new()

    case resource.(type, elastic_settings) do
      { type, elastic_settings } -> create_resource(type, elastic_settings)
    end
  end


  defp create_resource(type, opts) do
    cond do
      type[:settings] -> Tirexs.ElasticSearch.Settings.create_resource(type, opts)
      type[:mapping]  -> Tirexs.Mapping.create_resource(type, opts)
      type[:river]    -> Tirexs.River.create_resource(type, opts)
      type[:search]   -> Tirexs.Query.create_resource(type, opts)
    end
  end
end