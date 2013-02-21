defmodule Tirexs.DSL do
  use Tirexs.ElasticSettings

  def mapping(settings, mapping) do
    index = create_new_index(settings)
    elastic_settings = elastic_settings.new()
    case mapping.(index, elastic_settings) do
      [index, settings] -> Tirexs.put_mapping(settings, index)
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
end