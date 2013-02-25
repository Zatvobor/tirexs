defmodule Tirexs do
  import Tirexs.HTTP
  import Tirexs.Mapping.Json

  def init_index(type_name_list) do
    HashDict.new(type_name_list)
  end

  def put_mapping(settings, index) do
    index_name = index[:name]
    case index[:type] do
      nil ->
        url = "#{index_name}/_mapping"
        put(settings, url, get_json_mapping(index))
      type ->
        create_index(settings, index_name)
        url = "#{index_name}/#{index[:type]}/_mapping"
        put(settings, url, get_json_mapping(index))
    end
  end

  def get_json_mapping(index) do
    json_dict = to_json_proplist(index, :mapping)
    json_proplist = :erlson.from_nested_proplist(json_dict)
    :erlson.to_json(json_proplist)
  end

  def get_json_settings(index) do
    json_proplist = :erlson.from_nested_proplist([settings: index[:settings]])
    :erlson.to_json(json_proplist)
  end

  def get_json_river(river) do
    river = Dict.delete(river, :name)
    json_proplist = :erlson.from_nested_proplist(river)
    :erlson.to_json(json_proplist)
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
    json_proplist = :erlson.from_nested_proplist(params)
    json = :erlson.to_json(json_proplist)
    url = "#{url}/_search"
    IO.puts(json)
    post(settings, url, json)
  end

  def exist?(settings, url) do
    case head(settings, url) do
      [:error, _, _] -> false
      _ -> true
    end
  end
end
