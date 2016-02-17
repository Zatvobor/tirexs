defmodule Tirexs.ElasticSearch do


  @doc """
  Get default URI for `ElasticSearch` connection. Returns the value from `Application.get_env(:tirexs, :uri)`.
  """
  def config do
    IO.write :stderr, "warning: `Tirexs.Elasticsearch.config/0` is deprecated, please use `Tirexs.get_uri_env/0` instead\n" <> Exception.format_stacktrace
    Application.get_env(:tirexs, :uri)
  end

  @doc """
  Set `ElasticSearch` connection from URL.
  """
  def config(url) when is_bitstring(url) do
    IO.write :stderr, "warning: `Tirexs.Elasticsearch.config/1` is deprecated, and will be removed\n" <> Exception.format_stacktrace
    URI.parse(url)
  end

  @doc """
  Override default configuration for `ElasticSearch` connection from argument list.
  Arguments must match those in Elixir's `URI` module.
  """
  def config(opts) when is_list(opts) do
    IO.write :stderr, "warning: `Tirexs.Elasticsearch.config/1` is deprecated, and will be removed\n" <> Exception.format_stacktrace
    Map.merge(config, Enum.into(opts, %{}))
  end

  @doc false
  def config(config, part) do
    IO.write :stderr, "warning: `Tirexs.Elasticsearch.config/1` is deprecated, and will be removed\n" <> Exception.format_stacktrace
    config[part]
  end

  @doc false
  def get(query_url, config) do
    IO.write :stderr, "warning: `Tirexs.Elasticsearch.get/2` is deprecated, please use `Tirexs.HTTP.get/2` instead\n" <> Exception.format_stacktrace
    do_request(make_url(query_url, config), :get)
  end

  @doc false
  def put(query_url, config) do
    IO.write :stderr, "warning: `Tirexs.Elasticsearch.put/2` is deprecated, please use `Tirexs.HTTP.put/2` instead\n" <> Exception.format_stacktrace
    put(query_url, [], config)
  end

  def put(query_url, body, config) do
    IO.write :stderr, "warning: `Tirexs.Elasticsearch.put/3` is deprecated, please use `Tirexs.HTTP.put/3` instead\n" <> Exception.format_stacktrace
    unless body == [], do: body = to_string(body)
    do_request(make_url(query_url, config), :put, body)
  end

  @doc false
  def delete(query_url, config) do
    IO.write :stderr, "warning: `Tirexs.Elasticsearch.delete/2` is deprecated, please use `Tirexs.HTTP.delete/2` instead\n" <> Exception.format_stacktrace
    delete(query_url, [], config)
  end

  @doc false
  def delete(query_url, body, config) do
    IO.write :stderr, "warning: `Tirexs.Elasticsearch.delete/3` is deprecated, please use `Tirexs.HTTP.delete/3` instead\n" <> Exception.format_stacktrace
    unless body == [], do: body = to_string(body)
    do_request(make_url(query_url, config), :delete, body)
  end

  @doc false
  def head(query_url, config) do
    IO.write :stderr, "warning: `Tirexs.Elasticsearch.head/2` is deprecated, please use `Tirexs.HTTP.head/2` instead\n" <> Exception.format_stacktrace
    do_request(make_url(query_url, config), :head)
  end

  @doc false
  def post(query_url, config) do
    IO.write :stderr, "warning: `Tirexs.Elasticsearch.post/2` is deprecated, please use `Tirexs.HTTP.post/2` instead\n" <> Exception.format_stacktrace
    post(query_url, [], config)
  end

  def post(query_url, body, config) do
    IO.write :stderr, "warning: `Tirexs.Elasticsearch.post/3` is deprecated, please use `Tirexs.HTTP.post/3` instead\n" <> Exception.format_stacktrace
    unless body == [], do: body = to_string(body)
    url = make_url(query_url, config)
    do_request(url, :post, body)
  end

  @doc false
  def exist?(url, settings) do
    IO.write :stderr, "warning: `Tirexs.Elasticsearch.exist?/2` is deprecated, please use `Tirexs.HTTP.exist?/2` instead\n" <> Exception.format_stacktrace
    case head(url, settings) do
      {:error, _, _} -> false
      _ -> true
    end
  end


  @doc false
  def do_request(url, method, body \\ []) do
    { url, content_type, options } = { String.to_char_list(url), 'application/json', [{:body_format, :binary}] }
    case method do
      :get    -> ( request(method, {url, []}, [], []) |> response() )
      :head   -> ( request(method, {url, []}, [], []) |> response() )
      :delete -> ( request(method, {url, make_headers},[],[]) |> response() )
      :put    -> ( request(method, {url, make_headers, content_type, body}, [], options) |> response() )
      :post   -> ( request(method, {url, make_headers, content_type, body}, [], options) |> response() )
    end
  end


  defp request(method, request, http_options, options) do
    :httpc.request(method, request, http_options, options)
  end

  defp response(req) do
    case req do
      {:ok, { {_, status, _}, _, body}} ->
        if round(status / 100) == 4 || round(status / 100) == 5 do
          { :error, status, body }
        else
          case body do
            [] -> { :ok, status, [] }
            _  -> { :ok, status, get_body_json(body) }
          end
        end
      _ -> :error
    end
  end

  def get_body_json(body), do: JSX.decode!(to_string(body), [{:labels, :atom}])

  def make_url(query_url, config) do
    %URI{config | path: "/#{query_url}"} |> to_string
  end

  defp make_headers, do: [{'Content-Type', 'application/json'}]
end
