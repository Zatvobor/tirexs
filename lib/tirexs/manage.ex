defmodule Tirexs.Manage do
  import Tirexs.Helpers

  def count(options, settings) do
    body = JSON.encode(options[:filter] || options[:query] || [])
    Tirexs.ElasticSearch.post(make_url("_count", options), body, settings)
  end

  def delete_by_query(options, settings) do
    _body = JSON.encode(options[:filter] || options[:query] || [])
    #To do add DELETE with body
    Tirexs.ElasticSearch.delete(make_url("_query", options), settings)
  end

  def more_like_this(options, settings) do
    Tirexs.ElasticSearch.get(make_url("_mlt", options), settings)
  end

  def validate(options, settings) do
    body = JSON.encode(options[:filter] || options[:query] || [])
    if body == JSON.encode([]) do
      Tirexs.ElasticSearch.get(make_url("_validate/query", options), settings)
    else
      Tirexs.ElasticSearch.post(make_url("_validate/query", options), body, settings)
    end
  end

  def explain(options, settings) do
    Tirexs.ElasticSearch.get(make_url("_explain", options), settings)
  end

  def update(options, update_params, settings) do
    Tirexs.ElasticSearch.post(make_url("_update", options), JSON.encode(update_params), settings)
  end

  def create(:warmer, options, settings) do
    options = options ++ [warmer: true]
    warmers = options[:warmers]
    Tirexs.ElasticSearch.put("bear_test/_warmer/warmer_1", settings)
    Enum.each Dict.keys(warmers), fn(key) ->
      url = make_url(to_binary(key), options)
      body = JSON.encode(warmers[key][:source])
      Tirexs.ElasticSearch.put(url, body, settings)
    end
  end

  defp make_url(method, options) do
    index = options[:index] <> "/"
    if options[:type] do
      index = index <> options[:type] <> "/"
    end
    if options[:id] do
      index = index <> to_binary(options[:id]) <> "/"
    end

    if options[:warmer] do
      index = index <> "_warmer/"
    end

    options = delete_options([:filter, :query, :index, :type, :id, :warmer, :warmers], options)
    index <> method <> to_param(options, "")
  end

  defp delete_options([], options) do
    options
  end

  defp delete_options([h|t], options) do
    options = Dict.delete(options, h)
    delete_options(t, options)
  end
end