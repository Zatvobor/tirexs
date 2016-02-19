defmodule Tirexs.ElasticSearch do


  @doc """
  Get default URI for `ElasticSearch` connection. Returns the value from `Application.get_env(:tirexs, :uri)`.
  """
  def config do
    uri = Application.get_env(:tirexs, :uri)
    if Keyword.keyword?(uri) do
      Enum.reduce uri, %URI{}, fn ({key, value}, uri_struct) ->
        %{ uri_struct | key => value }
      end
    else
      uri
    end
  end

  @doc """
  Set `ElasticSearch` connection from URL.
  """
  def config(url) when is_bitstring(url) do
    URI.parse(url)
  end

  @doc """
  Override default configuration for `ElasticSearch` connection from argument list.
  Arguments must match those in Elixir's `URI` module.
  """
  def config(opts) when is_list(opts) do
    Map.merge(config, Enum.into(opts, %{}))
  end

  @doc false
  def config(config, part) do
    config[part]
  end

  @doc false
  def get(query_url, config) do
    do_request(make_url(query_url, config), :get)
  end

  @doc false
  def put(query_url, config), do: put(query_url, [], config)

  def put(query_url, body, config) do
    unless body == [], do: body = to_string(body)
    do_request(make_url(query_url, config), :put, body)
  end

  @doc false
  def delete(query_url, config), do: delete(query_url, [], config)

  @doc false
  def delete(query_url, body, config) do
    unless body == [], do: body = to_string(body)
    do_request(make_url(query_url, config), :delete, body)
  end

  @doc false
  def head(query_url, config) do
    do_request(make_url(query_url, config), :head)
  end

  @doc false
  def post(query_url, config), do: post(query_url, [], config)

  def post(query_url, body, config) do
    unless body == [], do: body = to_string(body)
    url = make_url(query_url, config)
    do_request(url, :post, body)
  end

  @doc false
  def exist?(url, settings) do
    case head(url, settings) do
      {:error, _, _} -> false
      _ -> true
    end
  end


  @doc false
  def do_request(url, method, body \\ []) do
    :inets.start()
    { url, content_type, options } = { String.to_char_list(url), 'application/json', [{:body_format, :binary}] }
    case method do
      :get    -> response(:httpc.request(method, {url, []}, [], []))
      :head   -> response(:httpc.request(method, {url, []}, [], []))
      :put    -> response(:httpc.request(method, {url, make_headers, content_type, body}, [], options))
      :post   -> response(:httpc.request(method, {url, make_headers, content_type, body}, [], options))
      :delete -> response(:httpc.request(method, {url, make_headers},[],[]))
    end
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
