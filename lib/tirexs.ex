defmodule Tirexs do
  import Tirexs.HTTP

  def init_index(type_name_list) do
    type_name_list
  end

  def put_mapping(settings, index) do
    index_name = index[:name]
    case index[:type] do
      nil ->
        url = "#{index_name}/_mapping"
        put(settings, url, get_json_mapping(index, index_name))
      type ->
        create_index(settings, index_name)
        url = "#{index_name}/#{index[:type]}/_mapping"
        put(settings, url, get_json_mapping(index, type))
    end
  end

  def get_json_mapping(index, name) do
    json_dict = Dict.put([], name, index[:mapping])
    JSON.encode(json_dict)
  end

  def get_json_settings(index) do
    JSON.encode([settings: index[:settings]])
  end

  def get_json_river(river) do
    river = Dict.delete(river, :name)
    JSON.encode(river)
  end

  def create_index(settings, url) do
    unless exist?(settings, url) do
      put(settings, url)
    end
  end

  def create_index_settings(settings, index) do
    url = index[:name]
    if exist?(settings, url) do
      delete(settings, url)
    end
    post(settings, url, get_json_settings(index))
  end

  def create_river(settings, river) do
    url = "_river/#{river[:name]}"
    if exist?(settings, url) do
      delete(settings, url)
    end
    url = "#{url}/_meta"
    put(settings, url, get_json_river(river))
  end

  def do_query(settings, url, params) do
    json = JSON.encode(params)
    url = "#{url}/_search"
    post(settings, url, json)
  end

  def exist?(settings, url) do
    case head(settings, url) do
      [:error, _, _] -> false
      _ -> true
    end
  end
end
