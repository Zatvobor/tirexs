defmodule Tirexs.Resources do
  @moduledoc """
  The intend is to provide an abstraction for dealing with ES resources.

  The interface of this module is aware about elasticsearch REST APIs conventions.
  Meanwhile, a `Tirexs.HTTP` provides just a general interface.

  """

  import Tirexs.HTTP


  @doc "the same as `ok?(head(path, uri))`"
  def exists?(path, uri), do: ok?(head(path, uri))
  def exists?(url_or_path_or_uri), do: ok?(head(url_or_path_or_uri))

  @doc "the same as `head!(path, uri)`"
  def exists!(path, uri), do: head!(path, uri)
  def exists!(url_or_path_or_uri), do: head!(url_or_path_or_uri)

  @doc """
  Composes an URN from parts into request ready path as a binary string.

  ## Examples:

      iex> urn ["bear_test", "/_alias", ["2015", "2016"]]
      "bear_test/_alias/2015,2016"

      iex> urn [["bear_test", "another_bear_test"], "_refresh", { [ignore_unavailable: true] }]
      "bear_test,another_bear_test/_refresh?ignore_unavailable=true"

      iex> urn("bear_test", "bear_type", "10", "_explain?analyzer=some")
      "bear_test/bear_type/10/_explain?analyzer=some"

  """
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
  def pluralize(resource) when is_integer(resource), do: to_string(resource)
  def pluralize(resource) when is_binary(resource), do: resource
  def pluralize(resource), do: Enum.join(resource, ",")

  @doc """
  Tries to bump resource. This one just makes a request and behaves like a proxy to
  one of avalable resource helper. You're able to bump any resources which are defined in
  `Tirexs.Resources.APIs`.

  Let's consider the following use case:

      iex> path = Tirexs.Resources.APIs._refresh(["bear_test", "duck_test"], { [force: false] })
      "bear_test,duck_test/_refresh?force=false"

      iex> Tirexs.HTTP.post(path)
      { :ok, 200, ... }

  With bump, the same is:

      iex> bump._refresh(["bear_test", "duck_test"], { [force: false] })
      { :ok, 200, ... }

  It is also available for bumping some resources with request body:

      iex> search = [query: [ term: [ user: "zatvobor" ] ] ]
      iex> bump(search)._count("bear_test", "my_type")
      { :ok, 200, ... }

      iex> payload = "{ \"index\": { \"_id\": \"2\" }}\n{ \"title\": \"My second blog post\" }\n"
      iex> bump(payload)._bulk("website", "blog", { [refresh: true] })
      { :ok, 200, ... }

  Play with resources you have and see what kind of HTTP verb is used.

  """
  def bump(), do: __t(:bump)
  def bump(%URI{} = uri), do: __t(:bump, [], uri)
  def bump(body), do: __t(:bump, body)
  def bump(body, %URI{} = uri), do: __t(:bump, body, uri)
  def bump!(), do: __t(:bump!)
  def bump!(%URI{} = uri), do: __t(:bump!, [], uri)
  def bump!(body), do: __t(:bump!, body)
  def bump!(body, %URI{} = uri), do: __t(:bump!, body, uri)


  @doc false
  def __c(urn, meta) when is_binary(urn) do
    if ctx = Process.delete(:tirexs_resources_chain) do
      args = case { urn, ctx[:body] } do
        { urn, [] }   -> [ urn, ctx[:uri] ]
        { urn, body } -> [ urn, ctx[:uri], body ]
      end
      Kernel.apply(Tirexs.HTTP, meta[ctx[:label]], args)
    else
      urn
    end
  end

  @doc false
  defp __t(label, body \\ [], %URI{} = uri \\ Tirexs.ENV.get_uri_env()) do
    Process.put(:tirexs_resources_chain, [label: label, body: body, uri: uri])
    Tirexs.Resources.APIs
  end
end
