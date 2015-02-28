defmodule Tirexs.Manage do
  import Tirexs.DSL.Logic

  def count(options, settings) do
    execute_get_if_body_empty_and_post_otherwise("_count", options, settings)
  end

  def delete_by_query(options, settings) do
    _body = JSX.encode!(options[:filter] || options[:query] || [])
    #To do add DELETE with body
    Tirexs.ElasticSearch.delete(make_url("_query", options), settings)
  end

  def more_like_this(options, settings) do
    Tirexs.ElasticSearch.get(make_url("_mlt", options), settings)
  end

  def validate(options, settings) do
    execute_get_if_body_empty_and_post_otherwise("_validate/query", options, settings)
  end

  def explain(options, settings) do
    Tirexs.ElasticSearch.get(make_url("_explain", options), settings)
  end

  def update(options, update_params, settings) do
    Tirexs.ElasticSearch.post(make_url("_update", options), JSX.encode!(update_params), settings)
  end

  def create(:warmer, options, settings) do
    options = options ++ [warmer: true]
    warmers = options[:warmers]
    Tirexs.ElasticSearch.put("bear_test/_warmer/warmer_1", settings)
    Enum.each Dict.keys(warmers), fn(key) ->
      url = make_url(to_string(key), options)
      body = JSX.encode!(warmers[key][:source])
      Tirexs.ElasticSearch.put(url, body, settings)
    end
  end

  def refresh(index, settings) when is_binary(index) do
    Tirexs.ElasticSearch.post(to_string(index) <> "/_refresh", settings)
  end

  def refresh(indexes, settings) when is_list(indexes) do
    indexes = Enum.join(indexes, ",")
    refresh(indexes, settings)
  end

  defp make_url(method, options) do
    index = options[:index] <> "/"
    if options[:type] do
      index = index <> options[:type] <> "/"
    end
    if options[:id] do
      index = index <> to_string(options[:id]) <> "/"
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

  defp execute_get_if_body_empty_and_post_otherwise(url_suffix, options, settings) do
    body =
      cond do
        options[:filter] -> options[:filter]
        options[:query] -> [query: options[:query]]
        true -> []
      end
    case JSX.encode!(body) do
      "[]" -> Tirexs.ElasticSearch.get(make_url(url_suffix, options), settings)
      body -> Tirexs.ElasticSearch.post(make_url(url_suffix, options), body, settings)
    end
  end
end