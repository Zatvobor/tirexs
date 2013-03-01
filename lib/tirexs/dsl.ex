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
    case [type[:settings], type[:mapping], type[:river]] do
      [_type, nil, nil] -> Tirexs.create_index_settings(settings, type)
      [nil, _type, nil] -> Tirexs.put_mapping(settings, type)
      [nil, nil, _type] -> Tirexs.create_river(settings, type)
    end
  end
end