defmodule Tirexs.Resources.Search do
  @moduledoc false

  import Tirexs.Resources, only: [urn: 1, __c: 2]


  @doc false
  @r [action: "/_explain", bump: :post, bump!: :post!]
  def _explain(a, b, c, d), do: __c(urn([a, b, c, @r[:action], d]), @r)
  def _explain(a, b, c), do: __c(urn([a, b, c, @r[:action]]), @r)
  def _explain(a, b), do: __c(urn([a, @r[:action], b]), @r)
  def _explain(a), do: __c(urn([a, @r[:action]]), @r)

  @r [action: "/_search_shards", bump: :get, bump!: :get!]
  def _search_shards(a, b, c), do: __c(urn([a, b, @r[:action], c]), @r)
  def _search_shards(a, {b}), do: __c(urn([a, @r[:action], {b}]), @r)
  def _search_shards(a, b), do: __c(urn([a, b, @r[:action]]), @r)
  def _search_shards(a), do: __c(urn([a, @r[:action]]), @r)
end
