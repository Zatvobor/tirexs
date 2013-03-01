defmodule Tirexs do

  def init_index(type_name_list) do
    type_name_list
  end

  def put_mapping(settings, index) do
    index_name = index[:name]
    case index[:type] do
      nil ->
        url = "#{index_name}/_mapping"
        Tirexs.ElasticSearch.put(url, get_json_mapping(index, index_name), settings)
      type ->
        create_index(settings, index_name)
        url = "#{index_name}/#{index[:type]}/_mapping"
        Tirexs.ElasticSearch.put(url, get_json_mapping(index, type), settings)
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
    river = Dict.delete(river, :river)
    JSON.encode(river)
  end

  def create_index(settings, url) do
    unless Tirexs.ElasticSearch.exist?(url, settings) do
      Tirexs.ElasticSearch.put(url, settings)
    end
  end

  def create_index_settings(settings, index) do
    url = index[:name]
    if Tirexs.ElasticSearch.exist?(url, settings) do
      Tirexs.ElasticSearch.delete(url, settings)
    end
    Tirexs.ElasticSearch.post(url, get_json_settings(index), settings)
  end

  def create_river(settings, river) do
    url = "_river/#{river[:name]}"
    if Tirexs.ElasticSearch.exist?(url, settings) do
      Tirexs.ElasticSearch.delete(url, settings)
    end
    url = "#{url}/_meta"
    Tirexs.ElasticSearch.put(url, get_json_river(river), settings)
  end

  def do_query(settings, url, params) do
    json = JSON.encode(params)
    url = "#{url}/_search"
    Tirexs.ElasticSearch.post(url, json, settings)
  end

  def do_search(settings, search) do
    url = case search[:type] do
      nil -> "#{search[:name]}/_search"
      type -> "#{search[:name]}/#{type}/_search"
    end
    do_query(settings, url, search[:search])
  end
end