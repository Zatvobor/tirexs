defmodule Tirexs.HTTP do
  @standard_http_adapter Tirexs.HTTP.Standard

  @moduledoc """
  A set of functions for working over HTTP.

  This bare-bone module provides all you need for getting things done over elasticsearch REST API.
  The functions designed to be handful for various possible use cases.

  A set of request functions such as `head/1-3`, `get/1-3`, `put/1-4`, `post/1-4` and `delete/1-3` also
  available with bangs functions. The bang functions raise `RuntimeError` exceptions.

      iex> get("unknown")
      {:error, 404, ... }

      iex> get!("unknown")
      ** (RuntimeError) {"error":{"root_cause": [{"type":"index_not_found_exception" ... }]

  The common set of allowed parameters are `path`, `params`, `uri` and `body`.

      iex> get("/bear_test/my_type/1")
      iex> get("/articles/document/1", [_source: false])
      iex> put("/bear_test/my_type/1?version=2", [user: "kimchy"])
      iex> put("/bear_test/my_type/1", [version: 2], [user: "kimchy"])
      iex> put("/bear_test/my_type/1", [version: 2], %URI{ host: "example.com" }, [user: "kimchy"])

  The `uri` parameter has a special purpose. You can use it for overriding any fields
  from application's environment uri (see `Tirexs.ENV.get_uri_env/0`).

      iex> Tirexs.get_uri_env()
      %URI{host: "127.0.0.1", port: 9200, scheme: "http"}

      iex> url("/articles/document/1")
      "http://127.0.0.1:9200/articles/document/1"

      iex> url("/articles/document/1", %URI{ port: 92, query: "_source=false" })
      "http://127.0.0.1:92/articles/document/1?_source=false"

  A query `params` could be as a part of `path` or used as a standalone `params`. The `params` param is allowed
  to be a `%{}` or `[]`.

      iex> put("/bear_test/my_type/1?version=2", [user: "kimchy"])
      iex> put("/bear_test/my_type/1", [version: 2], [user: "kimchy"])
      iex> put("/bear_test/my_type/1", %{version: 2}, %{user: "kimchy"})

  A request `body` is allowed to be a `Keyword` or `Map` instances or event just as `String`.

  """


  @doc "Sends a HEAD request."
  def head(path, params, %URI{} = uri) when is_binary(path) do
    do_request(:head, url(path, params, uri))
  end
  def head(path, %URI{} = uri) when is_binary(path) do
    do_request(:head, url(path, uri))
  end
  def head(url_or_path_or_uri, params) do
    do_request(:head, url(url_or_path_or_uri, params))
  end
  def head(url_or_path_or_uri) do
    do_request(:head, url(url_or_path_or_uri))
  end
  @doc "Sends a HEAD request and raise an exception if something wrong."
  def head!(a, b, c), do: ok!(head(a, b, c))
  def head!(a, b), do: ok!(head(a, b))
  def head!(a), do: ok!(head(a))

  @doc "Sends a GET request."
  def get(path, params, %URI{} = uri) when is_binary(path) do
    do_request(:get, url(path, params, uri))
  end
  def get(path, %URI{} = uri) when is_binary(path) do
    do_request(:get, url(path, uri))
  end
  def get(url_or_path_or_uri, params) do
    do_request(:get, url(url_or_path_or_uri, params))
  end
  def get(url_or_path_or_uri) do
    do_request(:get, url(url_or_path_or_uri))
  end
  @doc "Sends a GET request and raise an exception if something wrong."
  def get!(a, b, c), do: ok!(get(a, b, c))
  def get!(a, b), do: ok!(get(a, b))
  def get!(a), do: ok!(get(a))

  @doc "Sends a PUT request."
  def put(path, params, %URI{} = uri, []) when is_binary(path) do
    do_request(:put, url(path, params, uri))
  end
  def put(path, params, %URI{} = uri, body) when is_binary(path) and body == %{} do
    do_request(:put, url(path, params, uri))
  end
  def put(path, params, %URI{} = uri, body) when is_binary(path) and is_list(body) do
    put(path, params, uri, encode(body))
  end
  def put(path, params, %URI{} = uri, body) when is_binary(path) and is_map(body) do
    put(path, params, uri, encode(body))
  end
  def put(path, params, %URI{} = uri, body) when is_binary(path) and is_binary(body) do
    do_request(:put, url(path, params, uri), body)
  end
  def put(path, %URI{} = uri, []) when is_binary(path) do
    do_request(:put, url(path, uri))
  end
  def put(path, %URI{} = uri, body) when is_binary(path) and body == %{} do
    do_request(:put, url(path, uri))
  end
  def put(path, %URI{} = uri, body) when is_binary(path) and is_list(body) do
    put(path, uri, encode(body))
  end
  def put(path, %URI{} = uri, body) when is_binary(path) and is_map(body) do
    put(path, uri, encode(body))
  end
  def put(path, %URI{} = uri, body) when is_binary(path) and is_binary(body) do
    do_request(:put, url(path, uri), body)
  end
  def put(path, params, %URI{} = uri) when is_binary(path) do
    do_request(:put, url(path, params, uri))
  end
  def put(url_or_path_or_uri, params, []) do
    do_request(:put, url(url_or_path_or_uri, params))
  end
  def put(url_or_path_or_uri, params, body) when body == %{} do
    do_request(:put, url(url_or_path_or_uri, params))
  end
  def put(url_or_path_or_uri, params, body) when is_list(body) do
    put(url_or_path_or_uri, params, encode(body))
  end
  def put(url_or_path_or_uri, params, body) when is_map(body) do
    put(url_or_path_or_uri, params, encode(body))
  end
  def put(url_or_path_or_uri, params, body) when is_binary(body) do
    do_request(:put, url(url_or_path_or_uri, params), body)
  end
  def put(path, %URI{} = uri) when is_binary(path) do
    do_request(:put, url(path, uri))
  end
  def put(url_or_path_or_uri, []) do
    do_request(:put, url(url_or_path_or_uri))
  end
  def put(url_or_path_or_uri, body) when body == %{} do
    do_request(:put, url(url_or_path_or_uri))
  end
  def put(url_or_path_or_uri, body) when is_list(body) do
    put(url_or_path_or_uri, encode(body))
  end
  def put(url_or_path_or_uri, body) when is_map(body) do
    put(url_or_path_or_uri, encode(body))
  end
  def put(url_or_path_or_uri, body) when is_binary(body) do
    do_request(:put, url(url_or_path_or_uri), body)
  end
  def put(url_or_path_or_uri, params) do
    do_request(:put, url(url_or_path_or_uri, params))
  end
  def put(url_or_path_or_uri) do
    do_request(:put, url(url_or_path_or_uri))
  end
  @doc "Sends a PUT request and raise an exception if something wrong."
  def put!(a, b, c, d), do: ok!(put(a, b, c, d))
  def put!(a, b, c), do: ok!(put(a, b, c))
  def put!(a, b), do: ok!(put(a, b))
  def put!(a), do: ok!(put(a))

  @doc "Sends a POST request."
  def post(path, params, %URI{} = uri, []) when is_binary(path) do
    do_request(:post, url(path, params, uri))
  end
  def post(path, params, %URI{} = uri, body) when is_binary(path) and body == %{} do
    do_request(:post, url(path, params, uri))
  end
  def post(path, params, %URI{} = uri, body) when is_binary(path) and is_list(body) do
    post(path, params, uri, encode(body))
  end
  def post(path, params, %URI{} = uri, body) when is_binary(path) and is_map(body) do
    post(path, params, uri, encode(body))
  end
  def post(path, params, %URI{} = uri, body) when is_binary(path) and is_binary(body) do
    do_request(:post, url(path, params, uri), body)
  end
  def post(path, %URI{} = uri, []) when is_binary(path) do
    do_request(:post, url(path, uri))
  end
  def post(path, %URI{} = uri, body) when is_binary(path) and body == %{} do
    do_request(:post, url(path, uri))
  end
  def post(path, %URI{} = uri, body) when is_binary(path) and is_list(body) do
    post(path, uri, encode(body))
  end
  def post(path, %URI{} = uri, body) when is_binary(path) and is_map(body) do
    post(path, uri, encode(body))
  end
  def post(path, %URI{} = uri, body) when is_binary(path) and is_binary(body) do
    do_request(:post, url(path, uri), body)
  end
  def post(path, params, %URI{} = uri) when is_binary(path) do
    do_request(:post, url(path, params, uri))
  end
  def post(url_or_path_or_uri, params, []) do
    do_request(:post, url(url_or_path_or_uri, params))
  end
  def post(url_or_path_or_uri, params, body) when body == %{} do
    do_request(:post, url(url_or_path_or_uri, params))
  end
  def post(url_or_path_or_uri, params, body) when is_list(body) do
    post(url_or_path_or_uri, params, encode(body))
  end
  def post(url_or_path_or_uri, params, body) when is_map(body) do
    post(url_or_path_or_uri, params, encode(body))
  end
  def post(url_or_path_or_uri, params, body) when is_binary(body) do
    do_request(:post, url(url_or_path_or_uri, params), body)
  end
  def post(path, %URI{} = uri) when is_binary(path) do
    do_request(:post, url(path, uri))
  end
  def post(url_or_path_or_uri, []) do
    do_request(:post, url(url_or_path_or_uri))
  end
  def post(url_or_path_or_uri, body) when body == %{} do
    do_request(:post, url(url_or_path_or_uri))
  end
  def post(url_or_path_or_uri, body) when is_list(body) do
    post(url_or_path_or_uri, encode(body))
  end
  def post(url_or_path_or_uri, body) when is_map(body) do
    post(url_or_path_or_uri, encode(body))
  end
  def post(url_or_path_or_uri, body) when is_binary(body) do
    do_request(:post, url(url_or_path_or_uri), body)
  end
  def post(url_or_path_or_uri, params) do
    do_request(:post, url(url_or_path_or_uri, params))
  end
  def post(url_or_path_or_uri) do
    do_request(:post, url(url_or_path_or_uri))
  end
  @doc "Sends a POST request and raise an exception if something wrong."
  def post!(a, b, c, d), do: ok!(post(a, b, c, d))
  def post!(a, b, c), do: ok!(post(a, b, c))
  def post!(a, b), do: ok!(post(a, b))
  def post!(a), do: ok!(post(a))

  @doc "Sends a DELETE request."
  def delete(path, params, %URI{} = uri) when is_binary(path) do
    do_request(:delete, url(path, params, uri))
  end
  def delete(path, %URI{} = uri) when is_binary(path) do
    do_request(:delete, url(path, uri))
  end
  def delete(url_or_path_or_uri, params) do
    do_request(:delete, url(url_or_path_or_uri, params))
  end
  def delete(url_or_path_or_uri) do
    do_request(:delete, url(url_or_path_or_uri))
  end
  @doc "Sends a DELETE request and raise an exception if something wrong."
  def delete!(a, b, c), do: ok!(delete(a, b, c))
  def delete!(a, b), do: ok!(delete(a, b))
  def delete!(a), do: ok!(delete(a))

  @doc """
  Composes a complete URL by given params.

  ## Examples:

      iex> url()
      "http://127.0.0.1:9200"

      iex> url("/articles/document/1")
      "http://127.0.0.1:9200/articles/document/1"

      iex> url("/articles/document/1", %URI{ host: "example.com" })
      "http://example.com:9200/articles/document/1"

  Also see `Tirexs.Resources.urn/1`.

  """
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
  def url(url_or_path, params) when is_binary(url_or_path) and is_binary(params) do
    location = %URI{ URI.parse(url_or_path) | query: params }
    { default, given } = { Tirexs.get_uri_env(), __normalize_path__(location) }
    __merge__(default, given) |> to_string
  end
  def url(url_or_path, params) when is_binary(url_or_path) do
    location = %URI{ URI.parse(url_or_path) | query: URI.encode_query(params) }
    { default, given } = { Tirexs.get_uri_env(), __normalize_path__(location) }
    __merge__(default, given) |> to_string
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

  @doc """
  Returns `false` if `{ :error, _, _ } = response`, otherwise returns `true`.

  """
  def ok?(:error), do: false
  def ok?({ :error, _, _ }), do: false
  def ok?({ :ok, _, _ }), do: true

  @doc """
  Raises `RuntimeError` if `{ :error, _, _ } = response`, otherwise returns `response` back.

  """
  def ok!({ :error, _, error }), do: raise inspect(error)
  def ok!({ :ok, _, _ } = response), do: response

  def do_request(method, url, body \\ []) do
    http_adapter = Tirexs.ENV.get_env(:http_adapter, @standard_http_adapter)
    http_adapter.do_request(method, url, body)
    |> __response__()
  end

  @doc false
  def encode(term, opts \\ []) do
    JSX.encode!(term, opts)
  end

  @doc false
  def decode(json, opts \\ [{:labels, :atom}]) do
    with binary <- IO.iodata_to_binary(json),
         {:ok, decoded_json} <- JSX.decode(binary, opts) do
      decoded_json
    else
      {:error, msg} ->
        raise "Response is invalid JSON. Response: \"#{json}\". JSX Error: \"#{msg}\""
    end
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

  defp __response__({state, status, []}), do: { state, status, [] }
  defp __response__({state, status, body}), do: { state, status, decode(body) }
  defp __response__(:error), do: :error
end
