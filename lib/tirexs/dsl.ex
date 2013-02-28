defmodule Tirexs.DSL do
  use Tirexs.ElasticSettings

  def create(settings, resource) do
    index = create_new_index(settings)
    elastic_settings = elastic_settings.new()
    case resource.(index, elastic_settings) do
      [index, settings] -> create_resource(index, settings)

      _ -> raise "Shit happens!"
    end
  end

  def river(settings, river_settings) do
    elastic_settings = elastic_settings.new()
    river = Tirexs.River.init_river(settings)
    case river_settings.(river, elastic_settings) do
      [river, settings] -> Tirexs.create_river(settings, river)
      _ -> raise "Shit happens!"
    end
  end

  def create_new_index(setting) do
    Tirexs.init_index(setting)
  end

  def load_all(path) do
    Enum.each Path.wildcard(to_binary(path) <> "/*.exs"), fn(f) -> Code.load_file(f) end
  end

  def load(file) do
    to_binary(file) |> Code.load_file
  end

  defp create_resource(type, settings) do
    case [type[:settings], type[:mapping], type[:river]] do

      [_type, nil, nil] -> Tirexs.create_index_settings(settings, type)
      [nil, _type, nil] -> Tirexs.put_mapping(settings, type)
      [nil, nil, _type] -> Tirexs.create_river(settings, type)
      _                 -> raise "Shit happens!"
    end
  end

end