defmodule Tirexs.DSL do
  @moduledoc false

  @doc false
  def define(settings, resource) do
    index = Tirexs.init_index(settings)
    elastic_settings = Tirexs.ElasticSearch.Config.new()

    case resource.(index, elastic_settings) do
      [index, settings] -> create_resource(index, settings)
    end
  end


  defp create_resource(type, settings) do
    cond do
      type[:settings] -> Tirexs.create_index_settings(settings, type)
      type[:mapping]  -> Tirexs.put_mapping(settings, type)
      type[:river]    -> Tirexs.create_river(settings, type)
    end
  end
end