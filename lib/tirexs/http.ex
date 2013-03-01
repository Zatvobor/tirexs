defmodule Tirexs.HTTP do
  @moduledoc """
  This module implements functions for doing a `HTTP` request to `ElasticSearch` directly.
  """

  @doc false
  def get(settings, query_url) do
    do_request(composed_url(settings, query_url), :get)
  end

  @doc false
  def put(settings, query_url, body//[]) do
    unless body == [], do: body = to_binary(body)
    do_request(composed_url(settings, query_url), :put, body)
  end

  @doc false
  def delete(settings, query_url) do
    do_request(composed_url(settings, query_url), :delete)
  end

  @doc false
  def head(settings, query_url) do
    do_request(composed_url(settings, query_url), :head)
  end

  @doc false
  def post(settings, query_url, body//[]) do
    unless body == [], do: body = to_binary(body)
    do_request(composed_url(settings, query_url), :post, body)
  end

  @doc false
  def do_request(url, method, body//[]) do
    :inets.start()
    { url, content_type, options } = { binary_to_list(url), 'application/json', [{:body_format, :binary}] }

    case method do
      :get -> response(:httpc.request(method, {url, [make_headers]}, [], []))
      :head -> response(:httpc.request(method, {url, []}, [], []))
      :put -> response(:httpc.request(method, {url, make_headers, content_type, body}, [], options))
      :post -> response(:httpc.request(method, {url, make_headers, content_type, body}, [], options))
      :delete -> response(:httpc.request(method, {url, [make_headers]}, [], []))
    end
  end


  defp response(req) do
    case req do
      {:ok, { {_, status, _}, _, body}} ->
        if round(status / 100) == 4 || round(status / 100) == 5 do
          [:error, status, body]
        else
          case body do
            [] -> [:ok, status, []]
            _ -> [:ok, status, from_json(body)]
          end
        end
      _ -> :error
    end
  end

  defp from_json(text), do: JSON.decode(JSON.encode(text))

  defp make_headers, do: [{'Content-Type', 'application/json'}]

  defp composed_url(settings, query_url) do
    if settings.port == nil || settings.port == 80 do
      "http://#{settings.uri}/#{query_url}"
    else
      "http://#{settings.uri}:#{settings.port}/#{query_url}"
    end
  end
end