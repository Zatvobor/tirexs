defmodule Tirexs.ENV do
  @moduledoc false


  @doc false
  def default_uri_env(), do: %URI{ authority: "127.0.0.1:9200", scheme: "http", host: "127.0.0.1", port: 9200 }

  @doc false
  def get_uri_env(), do: get_env(:uri)

  @doc false
  def get_env(:uri) do
    __unwrap__(System.get_env("ES_URI") || Application.get_env(:tirexs, :uri))
  end
  def get_env(key) do
    Application.get_env(:tirexs, key)
  end

  @doc false
  def get_all_env(), do: Application.get_all_env(:tirexs)


  defp __unwrap__(uri) when is_binary(uri), do: URI.parse(uri)
  defp __unwrap__(uri) when is_list(uri),   do: Map.merge(%URI{}, Enum.into(uri, %{}))
  defp __unwrap__(%URI{} = uri),            do: uri
end
