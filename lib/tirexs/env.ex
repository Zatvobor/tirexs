defmodule Tirexs.ENV do
  @moduledoc """
  Represents environment-specific `%URI{}` struct. The struct has been used internally
  for building a request URL by default.

  The state of `Tirexs.ENV` is to made up a main `%URI{}` struct over
  `System.get_env("ES_URI")` or `Application.get_env(:tirexs, :uri)`.

  To setup your own uri to elasticsearch node you're able to useone of these available options:

  Environment variable:

      ES_URI=http://127.0.0.1:9200

  Over `Mix.Config.config/2`:

      config :tirexs, :uri, %URI{ authority: "127.0.0.1:9200", scheme: "http", host: "127.0.0.1", port: 9200 }
      config :tirexs, :uri, [ authority: "127.0.0.1:9200", scheme: "http", host: "127.0.0.1", port: 9200 ]
      config :tirexs, :uri, "http://127.0.0.1:9200"

  Over `Application.put_env/3`:

      put_env :tirexs, :uri, %URI{ authority: "127.0.0.1:9200", scheme: "http", host: "127.0.0.1", port: 9200 }
      put_env :tirexs, :uri, [ authority: "127.0.0.1:9200", scheme: "http", host: "127.0.0.1", port: 9200 ]
      put_env :tirexs, :uri, "http://127.0.0.1:9200"

  There is also an option to specify the `%URI{}` over parameter. For instance:

      iex> Tirexs.HTTP.url("/articles/document/1")
      "http://127.0.0.1:9200/articles/document/1"

      iex> Tirexs.HTTP.url("/articles/document/1", %URI{ host: "example.com" })
      "http://example.com:9200/articles/document/1"

  Hint: this works over merging between parameter and environment specific `%URI{}` struct. That's why
  the port number still is `9200`.

  The same interface is available across all of Tirexs functions.

  """

  @default_uri_env %URI{ authority: "127.0.0.1:9200", scheme: "http", host: "127.0.0.1", port: 9200 }
  @doc "Returns default environment such as `#{@default_uri_env}`"
  def default_uri_env(), do: @default_uri_env

  @doc """
  Returns the value over `System.get_env("ES_URI")` or `Application.get_env(:tirexs, :uri)`.
  See `get_env/1` for more details.
  """
  def get_uri_env(), do: get_env(:uri)

  @doc false
  def get_env(:uri) do
    __unwrap__(System.get_env("ES_URI") || Application.get_env(:tirexs, :uri))
  end

  @doc "Returns the value for `key` in `:tirexs`' environment."
  def get_env(key) do
    Application.get_env(:tirexs, key)
  end
  def get_env(key, default_value) do
    Application.get_env(:tirexs, key, default_value)
  end

  @doc "Returns all key-value pairs for `:tirexs` application."
  def get_all_env(), do: Application.get_all_env(:tirexs)


  defp __unwrap__(uri) when is_binary(uri), do: URI.parse(uri)
  defp __unwrap__(uri) when is_list(uri),   do: Map.merge(%URI{}, Enum.into(uri, %{}))
  defp __unwrap__(uri) when is_nil(uri),    do: __unwrap__(@default_uri_env)
  defp __unwrap__(%URI{} = uri),            do: uri
end
