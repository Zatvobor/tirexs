defmodule Tirexs.Index.Helpers do
  def put_setting(index, type) do
    settings = index[:settings]
    settings = Dict.put(settings, type, [])
    HashDict.put(index, :settings, settings)
  end

  def put_index_setting(index, type) do
    index_settings = index[:settings][:index]
    index_settings = Dict.put(index_settings, type, [])
    settings = Dict.put(index[:settings], :index, index_settings)
    HashDict.put(index, :settings, settings)
  end
end