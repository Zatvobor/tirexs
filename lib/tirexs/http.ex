defmodule Tirexs.HTTP do
  @moduledoc false


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
  def headers do
    [{'Content-Type', 'application/json'}]
  end

  @doc false
  def decode(body, opts \\ [{:labels, :atom}]) do
    JSX.decode!(to_string(body), opts)
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
