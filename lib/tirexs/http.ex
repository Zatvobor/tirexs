defmodule Tirexs.HTTP do

  def get(settings, query_url) do
    do_request(composed_url(settings, query_url), :get)
  end

  def put(settings, query_url, body//[]) do
    unless body == [] do
      body = to_binary(body)
    end
    do_request(composed_url(settings, query_url), :put, body)
  end

  def delete(settings, query_url) do
    do_request(composed_url(settings, query_url), :delete)
  end

  def head(settings, query_url) do
    do_request(composed_url(settings, query_url), :head)
  end

  def do_request(url, method, body//[]) do
    start()
    url = binary_to_list(url)
    content_type = 'application/json'
    options = [{:body_format, :binary}]

    case method do
      :get -> responce(:httpc.request(method, {url, [make_headers]}, [], []))
      :head -> responce(:httpc.request(method, {url, []}, [], []))
      :put -> responce(:httpc.request(method, {url, make_headers, content_type, body}, [], options))
      :post -> []
      :delete -> responce(:httpc.request(method, {url, [make_headers]}, [], []))
    end
  end

  defp start do
    case :inets.start() do
      {:error, _ } -> :error
      :ok -> :ok
    end
  end

  defp responce(req) do
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

  defp from_json(text) do
    :erlson.from_json(text)
    # :mochijson.decode(text)
  end

  defp make_headers do
     [{'Content-Type', 'application/json'}]
  end

  defp composed_url(settings, query_url) do
    if settings.port == nil || settings.port == 80 do
      "http://#{settings.uri}/#{query_url}"
    else
      "http://#{settings.uri}:#{settings.port}/#{query_url}"
    end
  end

end