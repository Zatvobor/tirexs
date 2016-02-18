defmodule Tirexs.HTTP do
  @moduledoc false


  @doc false
  def head(path, uri) when is_binary(path) and is_map(uri) do
    do_request(:head, url(path, uri))
  end
  def head(url_or_path_or_uri) do
    do_request(:head, url(url_or_path_or_uri))
  end

  @doc false
  def get(path, uri) when is_binary(path) and is_map(uri) do
    do_request(:get, url(path, uri))
  end
  def get(url_or_path_or_uri) do
    do_request(:get, url(url_or_path_or_uri))
  end

  @doc false
  def put(path, uri, body) when is_binary(path) and is_map(uri) and is_list(body) do
    if body == [], do: do_request(:put, url(path, uri)), else: put(path, uri, to_string(body))
  end
  def put(path, uri, body) when is_binary(path) and is_map(uri) and is_binary(body) do
    do_request(:put, url(path, uri), body)
  end
  def put(path, uri) when is_binary(path) and is_map(uri) do
    do_request(:put, url(path, uri))
  end
  def put(url_or_path_or_uri, body) when is_list(body) do
    if body == [], do: do_request(:put, url(url_or_path_or_uri)), else: put(url_or_path_or_uri, to_string(body))
  end
  def put(url_or_path_or_uri, body) when is_binary(body) do
    do_request(:put, url(url_or_path_or_uri), body)
  end
  def put(url_or_path_or_uri) do
    do_request(:put, url(url_or_path_or_uri))
  end

  @doc false
  def post(path, uri, body) when is_binary(path) and is_map(uri) and is_list(body) do
    if body == [], do: do_request(:post, url(path, uri)), else: post(path, uri, to_string(body))
  end
  def post(path, uri, body) when is_binary(path) and is_map(uri) and is_binary(body) do
    do_request(:post, url(path, uri), body)
  end
  def post(path, uri) when is_binary(path) and is_map(uri) do
    do_request(:post, url(path, uri))
  end
  def post(url_or_path_or_uri, body) when is_list(body) do
    if body == [], do: do_request(:post, url(url_or_path_or_uri), body), else: post(url_or_path_or_uri, to_string(body))
  end
  def post(url_or_path_or_uri, body) when is_binary(body) do
    do_request(:post, url(url_or_path_or_uri), body)
  end
  def post(url_or_path_or_uri) do
    do_request(:post, url(url_or_path_or_uri))
  end

  @doc false
  def delete(path, uri) when is_binary(path) and is_map(uri) do
    do_request(:delete, url(path, uri))
  end
  def delete(url_or_path_or_uri) do
    do_request(:delete, url(url_or_path_or_uri))
  end

  @doc false
  def url(path, uri) when is_binary(path) and is_map(uri) do
    { default, given } = { Tirexs.get_uri_env(), __normalize_path__(uri) }
    %URI{ __merge__(default, given) | path: __normalize_path__(path) } |> to_string
  end
  def url(url_or_path) when is_binary(url_or_path) do
    { default, given } = { Tirexs.get_uri_env(), __normalize_path__(URI.parse(url_or_path)) }
    __merge__(default, given) |> to_string
  end
  def url(uri) when is_map(uri) do
    { default, given } = { Tirexs.get_uri_env(), __normalize_path__(uri) }
    __merge__(default, given) |> to_string
  end
  def url(), do: url(Tirexs.get_uri_env())


  @doc false
  def do_request(method, url, body \\ []) do
    { url, content_type, options } = { String.to_char_list(url), 'application/json', [{:body_format, :binary}] }
    case method do
      :get    -> ( request(method, {url, []}, [], []) |> response() )
      :head   -> ( request(method, {url, []}, [], []) |> response() )
      :delete -> ( request(method, {url, headers},[],[]) |> response() )
      :put    -> ( request(method, {url, headers, content_type, body}, [], options) |> response() )
      :post   -> ( request(method, {url, headers, content_type, body}, [], options) |> response() )
    end
  end

  @doc false
  def request(method, request, http_options, options) do
    :application.ensure_all_started(:tirexs)
    :httpc.request(method, request, http_options, options)
  end

  @doc false
  def response(req) do
    case req do
      {:ok, { {_, status, _}, _, body}} ->
        if round(status / 100) == 4 || round(status / 100) == 5 do
          { :error, status, body }
        else
          case body do
            [] -> { :ok, status, [] }
            _  -> { :ok, status, decode(body) }
          end
        end
      _ -> :error
    end
  end

  @doc false
  def headers do
    [{'Content-Type', 'application/json'}]
  end

  @doc false
  def decode(json, opts \\ [{:labels, :atom}]) do
    JSX.decode(to_string(json), opts)
  end

  @doc false
  def encode(term, opts \\ []) do
    JSX.encode(term, opts)
  end


  defp __merge__(map1, map2) do
    Map.merge(map1, map2, fn(_k, v1, v2) ->
      v2 || v1
    end)
  end

  defp __normalize_path__(uri) when is_map(uri) do
    %URI{ uri | path: __normalize_path__(uri.path) }
  end
  defp __normalize_path__(path) when is_binary(path) do
    if String.starts_with?(path, "/"), do: path, else: "/" <> path
  end
  defp __normalize_path__(path), do: path
end
