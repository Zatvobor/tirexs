defmodule Tirexs.HTTP do
  @moduledoc false


  @doc false
  def url(path, uri) when is_binary(path) and is_map(uri) do
    %URI{ } |> to_string
  end
  def url(url_or_path) when is_binary(url_or_path) do
    %URI{ } |> to_string
  end
  def url(uri) when is_map(uri) do
    %URI{ } |> to_string
  end

  @doc false
  def headers do
    [{'Content-Type', 'application/json'}]
  end

  @doc false
  def decode(body, opts \\ [{:labels, :atom}]) do
    JSX.decode!(to_string(body), opts)
  end
end
