defmodule Tirexs.DSL do
  @moduledoc """
  This module represents a main entry point for defining DSL scenarios.
  Check an `examples` directory which consists a DSL tempaltes for `mapping`, `settings`, `query` and `river`.
  """

  @doc false
  def define(settings, resource) do
    index = Tirexs.init_index(settings)
    elastic_settings = Tirexs.ElasticSearch.Config.new()

    case resource.(index, elastic_settings) do
      { index, settings } -> create_resource(index, settings)
    end
  end


  defp create_resource(type, settings) do
    cond do
      type[:settings] -> Tirexs.ElasticSearch.Settings.create_resource(type, settings)
      type[:mapping]  -> Tirexs.Mapping.create_resource(type, settings)
      type[:river]    -> Tirexs.River.create_resource(type, settings)
      type[:search]   -> Tirexs.do_search(settings, type)
    end
  end
end