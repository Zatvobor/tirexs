defmodule Tirexs.Resources do
  @moduledoc false

  import Tirexs.HTTP


  @doc false
  def exists?(path, uri) when is_binary(path) and is_map(uri) do
    ok?(head(path, uri))
  end
  def exists?(url_or_path_or_uri) do
    ok?(head(url_or_path_or_uri))
  end
  def exists!(path, uri) when is_binary(path) and is_map(uri) do
    head!(path, uri)
  end
  def exists!(url_or_path_or_uri) do
    head!(url_or_path_or_uri)
  end

  @doc false
  def urn(part) when is_binary(part) do
    normalize(part)
  end
  def urn(parts)  when is_list(parts) do
    Enum.map(parts, fn(part) -> normalize(part) end) |> Enum.join("/") |> String.replace("/?", "?")
  end
  def urn(a, b), do: urn([a ,b])
  def urn(a, b, c), do: urn([a,b,c])
  def urn(a, b, c, d), do: urn([a,b,c,d])
  def urn(a, b, c, d, e), do: urn([a,b,c,d,e])
  def urn(a, b, c, d, e, f), do: urn([a,b,c,d,e,f])
  def urn(a, b, c, d, e, f, g), do: urn([a,b,c,d,e,f,g])

  @doc false
  def normalize(resource) when is_binary(resource) do
    String.strip(resource) |> String.replace_prefix("/", "")
  end
  def normalize({ params }) do
    "?" <> URI.encode_query(params)
  end
  def normalize(resource) do
    pluralize(resource) |> normalize()
  end

  @doc false
  def pluralize(resource) when is_binary(resource), do: resource
  def pluralize(resource), do: Enum.join(resource, ",")

  @doc false
  def bump(), do: __t(:bump)
  def bump(uri), do: __t(:bump, uri)
  def bump!(), do: __t(:bump!)
  def bump!(uri), do: __t(:bump!, uri)


  @doc false
  def __c(urn, meta) do
    if ctx = Process.delete(:tirexs_resources_chain) do
      args = case urn do
        urn when is_binary(urn) -> [ urn, ctx[:uri] ]
        [ urn, body ]           -> [ urn, ctx[:uri], body ]
      end
      Kernel.apply(Tirexs.HTTP, meta[ctx[:label]], args)
    else
      urn
    end
  end

  @doc false
  defp __t(label, uri \\ Tirexs.ENV.get_uri_env()) do
    Process.put(:tirexs_resources_chain, [label: label, uri: uri])
    Tirexs.Resources.APIs
  end
end
