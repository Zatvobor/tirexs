defmodule Tirexs.HTTP do
  @moduledoc """
  A set of functions for working over HTTP.

  This bare-bone module provides all you need for getting things done over elasticsearch REST API.
  The functions designed to be handful for various possible use cases.

  A set of request functions such as `head/1-3`, `get/1-3`, `put/1-4`, `post/1-4` and `delete/1-3` also
  available with bangs functions. The bang! functions could raise a RuntimeError.

      iex> get("unknown")
      {:error, 404, _ }

      iex> get!("unknown")
      ** (RuntimeError) {"error":{"root_cause": [{"type":"index_not_found_exception" ... }]

  The common set of allowed parameters are `path`, `params`, `uri` and `body`.

      iex> { :ok, 200, _ } = get("/bear_test/my_type/1")
      iex> { :ok, 200, _ } = put("/bear_test/my_type/1", [version: 2], [user: "kimchy", id: 1])
      iex> { :ok, 200, _ } = put("/bear_test/my_type/1", [version: 2], %URI{ host: "example.com" }, [user: "kimchy", id: 1])

  The `uri` parameter has a special purpose. You can use it for overriding any fields
  from application's environment uri (`Tirexs.get_uri_env/0`).

      iex> Tirexs.get_uri_env()
      %URI{host: "127.0.0.1", port: 9200, scheme: "http"}

      iex> get("/articles/document/1")
      "http://127.0.0.1:9200/articles/document/1?_source=false"

      iex> get("/articles/document/1", %URI{ port: 92 })
      "http://127.0.0.1:92/articles/document/1?_source=false"

  A query params could be as a part of `path` or used as a standalone `params`. A `body` param is allowed
  to be a `%{}` or `[]`.

      iex> put("/bear_test/my_type/1?version=2", [user: "kimchy", id: 1])
      iex> put("/bear_test/my_type/1", [version: 2], [user: "kimchy", id: 1])
      iex> put("/bear_test/my_type/1", %{version: 2}, %{user: "kimchy", id: 1})
  """

  @typedoc "The Uniform Resource Identifier"
  @type uri :: URI.t
  @type url :: String.t

  @typedoc "The response from server"
  @type response :: { :ok, integer, map } | { :error, integer, map }

  @typedoc "The boolean statement of server response"
  @type response? :: boolean

  @typedoc "The bung of server response"
  @type response! :: response | no_return

  @typedoc "The path as part of request url"
  @type path :: String.t
  @type url_or_path :: url | path
  @type url_or_path_or_uri :: path | uri

  @typedoc "The query params as a part of request url"
  @type params :: String.t | [{atom, String.t}] | map

  @typedoc "The response body"
  @type body :: map


  @doc """
  Sends a HEAD request.

  """
  @spec head(path, params, uri) :: response
  def head(path, params, %URI{} = uri) when is_binary(path) do
    do_request(:head, url(path, params, uri))
  end
  @spec head(path, uri) :: response
  def head(path, %URI{} = uri) when is_binary(path) do
    do_request(:head, url(path, uri))
  end
  @spec head(url_or_path_or_uri, params) :: response
  def head(url_or_path_or_uri, params) do
    do_request(:head, url(url_or_path_or_uri, params))
  end
  @spec head(url_or_path_or_uri) :: response
  def head(url_or_path_or_uri) do
    do_request(:head, url(url_or_path_or_uri))
  end
  @spec head!(term, term, term) :: response!
  def head!(a, b, c), do: ok!(head(a, b, c))
  @spec head!(term, term) :: response!
  def head!(a, b), do: ok!(head(a, b))
  @spec head!(term) :: response!
  def head!(a), do: ok!(head(a))

  @doc """
  Sends a GET request.

  """
  @spec get(path, params, uri) :: response
  def get(path, params, %URI{} = uri) when is_binary(path) do
    do_request(:get, url(path, params, uri))
  end
  @spec get(path, uri) :: response
  def get(path, %URI{} = uri) when is_binary(path) do
    do_request(:get, url(path, uri))
  end
  @spec get(url_or_path_or_uri, params) :: response
  def get(url_or_path_or_uri, params) do
    do_request(:get, url(url_or_path_or_uri, params))
  end
  @spec get(url_or_path_or_uri) :: response
  def get(url_or_path_or_uri) do
    do_request(:get, url(url_or_path_or_uri))
  end
  @spec get!(term, term, term) :: response!
  def get!(a, b, c), do: ok!(get(a, b, c))
  @spec get!(term, term) :: response!
  def get!(a, b), do: ok!(get(a, b))
  @spec get!(term) :: response!
  def get!(a), do: ok!(get(a))

  @doc """
  Sends a PUT request.

  """
  @spec put(path, params, uri, body) :: response
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
  @spec put(path, uri, body) :: response
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
  @spec put(path, params, uri) :: response
  def put(path, params, %URI{} = uri) when is_binary(path) do
    do_request(:put, url(path, params, uri))
  end
  @spec put(url_or_path_or_uri, params, body) :: response
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
  @spec put(path, uri) :: response
  def put(path, %URI{} = uri) when is_binary(path) do
    do_request(:put, url(path, uri))
  end
  @spec put(url_or_path_or_uri, body) :: response
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
  @spec put(url_or_path_or_uri, params) :: response
  def put(url_or_path_or_uri, params) do
    do_request(:put, url(url_or_path_or_uri, params))
  end
  @spec put(url_or_path_or_uri) :: response
  def put(url_or_path_or_uri) do
    do_request(:put, url(url_or_path_or_uri))
  end
  @spec put!(term, term, term, term) :: response!
  def put!(a, b, c, d), do: ok!(put(a, b, c, d))
  @spec put!(term, term, term) :: response!
  def put!(a, b, c), do: ok!(put(a, b, c))
  @spec put!(term, term) :: response!
  def put!(a, b), do: ok!(put(a, b))
  @spec put!(term) :: response!
  def put!(a), do: ok!(put(a))

  @doc """
  Sends a POST request.

  """
  @spec post(path, params, uri, body) :: response
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
  @spec post(path, uri, body) :: response
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
  @spec post(path, params, uri) :: response
  def post(path, params, %URI{} = uri) when is_binary(path) do
    do_request(:post, url(path, params, uri))
  end
  @spec post(url_or_path_or_uri, params, body) :: response
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
  @spec post(path, uri) :: response
  def post(path, %URI{} = uri) when is_binary(path) do
    do_request(:post, url(path, uri))
  end
  @spec post(path, body) :: response
  def post(url_or_path_or_uri, []) do
    do_request(:post, url(url_or_path_or_uri))
  end
  @spec post(url_or_path_or_uri, body) :: response
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
  @spec post(url_or_path_or_uri, params) :: response
  def post(url_or_path_or_uri, params) do
    do_request(:post, url(url_or_path_or_uri, params))
  end
  @spec post(url_or_path_or_uri) :: response
  def post(url_or_path_or_uri) do
    do_request(:post, url(url_or_path_or_uri))
  end
  @spec post!(term, term, term, term) :: response!
  def post!(a, b, c, d), do: ok!(post(a, b, c, d))
  @spec post!(term, term, term) :: response!
  def post!(a, b, c), do: ok!(post(a, b, c))
  @spec post!(term, term) :: response!
  def post!(a, b), do: ok!(post(a, b))
  @spec post!(term) :: response!
  def post!(a), do: ok!(post(a))

  @doc """
  Sends a DELETE request.

  """
  @spec delete(path, params, uri) :: response
  def delete(path, params, %URI{} = uri) when is_binary(path) do
    do_request(:delete, url(path, params, uri))
  end
  @spec delete(path, uri) :: response
  def delete(path, %URI{} = uri) when is_binary(path) do
    do_request(:delete, url(path, uri))
  end
  @spec delete(path, url_or_path_or_uri, params) :: response
  def delete(url_or_path_or_uri, params) do
    do_request(:delete, url(url_or_path_or_uri, params))
  end
  @spec delete(path, url_or_path_or_uri) :: response
  def delete(url_or_path_or_uri) do
    do_request(:delete, url(url_or_path_or_uri))
  end
  @spec delete!(term, term, term) :: response!
  def delete!(a, b, c), do: ok!(delete(a, b, c))
  @spec delete!(term, term) :: response!
  def delete!(a, b), do: ok!(delete(a, b))
  @spec delete!(term) :: response!
  def delete!(a), do: ok!(delete(a))

  @doc """
  Builds a complete URL by given parts.

  """
  @spec url(path, params, uri) :: url
  def url(path, params, %URI{} = uri) when is_binary(path) and is_binary(params) do
    url(path, %URI{ uri | query: params })
  end
  def url(path, params, %URI{} = uri) when is_binary(path) do
    url(path, %URI{ uri | query: URI.encode_query(params) })
  end
  @spec url(path, uri) :: url
  def url(path, %URI{} = uri) when is_binary(path) do
    { default, given } = { Tirexs.get_uri_env(), __normalize_path__(uri) }
    %URI{ __merge__(default, given) | path: __normalize_path__(path) } |> to_string
  end
  @spec url(url_or_path, params) :: url
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
  @spec url(url_or_path) :: url
  def url(url_or_path) when is_binary(url_or_path) do
    { default, given } = { Tirexs.get_uri_env(), __normalize_path__(URI.parse(url_or_path)) }
    __merge__(default, given) |> to_string
  end
  @spec url(uri) :: url
  def url(%URI{} = uri) do
    { default, given } = { Tirexs.get_uri_env(), __normalize_path__(uri) }
    __merge__(default, given) |> to_string
  end
  @spec url() :: url
  def url(), do: url(Tirexs.get_uri_env())

  @doc """
  Returns `false` if `{ :error, _, _ } = response`, otherwise returns `true`.

  """
  @spec ok?(response) :: response?
  def ok?(response) do
    case response do
      { :error, _, _ } -> false
      _                -> true
    end
  end

  @doc """
  Raises `RuntimeError` if `{ :error, _, _ } = response`, otherwise returns `response` back.

  """
  @spec ok!(response) :: response!
  def ok!(response) do
    case response do
      { :error, _, error } -> raise to_string(error)
      _                    -> response
    end
  end


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
