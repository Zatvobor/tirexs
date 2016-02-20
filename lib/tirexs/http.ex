defmodule Tirexs.HTTP do
  @moduledoc false


  @doc false
  def head(path, %URI{} = uri) when is_binary(path) do
    do_request(:head, url(path, uri))
  end
  def head(url_or_path_or_uri) do
    do_request(:head, url(url_or_path_or_uri))
  end
  def head!(path, %URI{} = uri) when is_binary(path) do
    ok!(head(path, uri))
  end
  def head!(url_or_path_or_uri) do
    ok!(head(url_or_path_or_uri))
  end

  @doc false
  def get(path, %URI{} = uri) when is_binary(path) do
    do_request(:get, url(path, uri))
  end
  def get(url_or_path_or_uri) do
    do_request(:get, url(url_or_path_or_uri))
  end

  @doc false
  def put(path, %URI{} = uri, []) when is_binary(path) do
    do_request(:put, url(path, uri))
  end
  def put(path, %URI{} = uri, body) when is_binary(path) and is_list(body) do
    put(path, uri, encode(body))
  end
  def put(path, %URI{} = uri, %{}) when is_binary(path) do
    do_request(:put, url(path, uri))
  end
  def put(path, %URI{} = uri, body) when is_binary(path) and is_map(body) do
    put(path, uri, encode(body))
  end
  def put(path, %URI{} = uri, body) when is_binary(path) and is_binary(body) do
    do_request(:put, url(path, uri), body)
  end
  def put(path, %URI{} = uri) when is_binary(path) and is_map(uri) do
    do_request(:put, url(path, uri))
  end
  def put(url_or_path_or_uri, []) do
    do_request(:put, url(url_or_path_or_uri))
  end
  def put(url_or_path_or_uri, body) when is_list(body) do
    put(url_or_path_or_uri, encode(body))
  end
  def put(url_or_path_or_uri, %{}) do
    do_request(:put, url(url_or_path_or_uri))
  end
  def put(url_or_path_or_uri, body) when is_map(body) do
    put(url_or_path_or_uri, encode(body))
  end
  def put(url_or_path_or_uri, body) when is_binary(body) do
    do_request(:put, url(url_or_path_or_uri), body)
  end
  def put(url_or_path_or_uri) do
    do_request(:put, url(url_or_path_or_uri))
  end

  @doc false
  def post(path, %URI{} = uri, []) when is_binary(path) do
    do_request(:post, url(path, uri))
  end
  def post(path, %URI{} = uri, body) when is_binary(path) and is_list(body) do
    post(path, uri, encode(body))
  end
  def post(path, %URI{} = uri, %{}) when is_binary(path) do
    do_request(:post, url(path, uri))
  end
  def post(path, %URI{} = uri, body) when is_binary(path) and is_map(body) do
    post(path, uri, encode(body))
  end
  def post(path, %URI{} = uri, body) when is_binary(path) and is_binary(body) do
    do_request(:post, url(path, uri), body)
  end
  def post(path, %URI{} = uri) when is_binary(path) and is_map(uri) do
    do_request(:post, url(path, uri))
  end
  def post(url_or_path_or_uri, []) do
    do_request(:post, url(url_or_path_or_uri))
  end
  def post(url_or_path_or_uri, body) when is_list(body) do
    post(url_or_path_or_uri, encode(body))
  end
  def post(url_or_path_or_uri, %{}) do
    do_request(:post, url(url_or_path_or_uri))
  end
  def post(url_or_path_or_uri, body) when is_map(body) do
    post(url_or_path_or_uri, encode(body))
  end
  def post(url_or_path_or_uri, body) when is_binary(body) do
    do_request(:post, url(url_or_path_or_uri), body)
  end
  def post(url_or_path_or_uri) do
    do_request(:post, url(url_or_path_or_uri))
  end

  @doc false
  def delete(path, %URI{} = uri) when is_binary(path) do
    do_request(:delete, url(path, uri))
  end
  def delete(url_or_path_or_uri) do
    do_request(:delete, url(url_or_path_or_uri))
  end

  @doc false
  def url(path, params, %URI{} = uri) when is_binary(path) and is_binary(params) do
    url(path, %URI{ uri | query: params })
  end
  def url(path, params, %URI{} = uri) when is_binary(path) do
    url(path, %URI{ uri | query: URI.encode_query(params) })
  end
  def url(path, %URI{} = uri) when is_binary(path) do
    { default, given } = { Tirexs.get_uri_env(), __normalize_path__(uri) }
    %URI{ __merge__(default, given) | path: __normalize_path__(path) } |> to_string
  end
  def url(url_or_path) when is_binary(url_or_path) do
    { default, given } = { Tirexs.get_uri_env(), __normalize_path__(URI.parse(url_or_path)) }
    __merge__(default, given) |> to_string
  end
  def url(%URI{} = uri) do
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
    { :ok, _ } = :application.ensure_all_started(:tirexs)
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
  def ok?(response) do
    case response do
      { :error, _, _ } -> false
      _                -> true
    end
  end

  @doc false
  def ok!(response) do
    case response do
      { :error, _, error } -> raise to_string(error)
      _                    -> response
    end
  end


  @doc false
  def headers do
    [{'Content-Type', 'application/json'}]
  end

  @doc false
  def decode(json, opts \\ [{:labels, :atom}]) do
    JSX.decode!(to_string(json), opts)
  end

  @doc false
  def encode(term, opts \\ []) do
    JSX.encode!(term, opts)
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
