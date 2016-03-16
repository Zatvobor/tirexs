defmodule Tirexs.Resources.Search do
  @moduledoc false

  import Tirexs.Resources, only: [urn: 1, __c: 2]


  @doc false
  @r [action: "/_explain", bump: :post, bump!: :post!]
  def _explain(a, b, c, d), do: __c(urn([a, b, c, @r[:action], d]), @r)
  def _explain(a, b, c), do: __c(urn([a, b, c, @r[:action]]), @r)
  def _explain(a, b), do: __c(urn([a, @r[:action], b]), @r)
  def _explain(a), do: __c(urn([a, @r[:action]]), @r)

  @doc false
  @r [action: "/_search_shards", bump: :get, bump!: :get!]
  def _search_shards(a, b, c), do: __c(urn([a, b, @r[:action], c]), @r)
  def _search_shards(a, {b}), do: __c(urn([a, @r[:action], {b}]), @r)
  def _search_shards(a, b), do: __c(urn([a, b, @r[:action]]), @r)
  def _search_shards(a), do: __c(urn([a, @r[:action]]), @r)

  @doc false
  @r [action: "/_field_stats", bump: :post, bump!: :post!]
  def _field_stats(a, b), do: __c(urn([a, @r[:action], b]), @r)
  def _field_stats({a}), do: __c(urn([@r[:action], {a}]), @r)
  def _field_stats(a), do: __c(urn([a, @r[:action]]), @r)
  def _field_stats(), do: __c(urn([@r[:action]]), @r)

  @doc false
  @r [action: "/_validate/query", bump: :post, bump!: :post!]
  def _validate_query(a, b, c), do: __c(urn([a, b, @r[:action], c]), @r)
  def _validate_query(a, {b}), do: __c(urn([a, @r[:action], {b}]), @r)
  def _validate_query(a, b), do: __c(urn([a, b, @r[:action]]), @r)
  def _validate_query({a}), do: __c(urn([@r[:action], {a}]), @r)
  def _validate_query(a), do: __c(urn([a, @r[:action]]), @r)
  def _validate_query(), do: __c(urn([@r[:action]]), @r)

  @doc false
  @r [action: "/_count", bump: :post, bump!: :post!]
  def _count(a, b, c), do: __c(urn([a, b, @r[:action], c]), @r)
  def _count(a, {b}), do: __c(urn([a, @r[:action], {b}]), @r)
  def _count(a, b), do: __c(urn([a, b, @r[:action]]), @r)
  def _count({a}), do: __c(urn([@r[:action], {a}]), @r)
  def _count(a), do: __c(urn([a, @r[:action]]), @r)
  def _count(), do: __c(urn([@r[:action]]), @r)

  @doc false
  @r [action: "/_search/exists", bump: :post, bump!: :post!]
  def _search_exists(a, b, c), do: __c(urn([a, b, @r[:action], c]), @r)
  def _search_exists(a, {b}), do: __c(urn([a, @r[:action], {b}]), @r)
  def _search_exists(a, b), do: __c(urn([a, b, @r[:action]]), @r)
  def _search_exists({a}), do: __c(urn([@r[:action], {a}]), @r)
  def _search_exists(a), do: __c(urn([a, @r[:action]]), @r)
  def _search_exists(), do: __c(urn([@r[:action]]), @r)

  @doc false
  @r [action: "/_search", bump: :post, bump!: :post!]
  def _search(a, b, c), do: __c(urn([a, b, @r[:action], c]), @r)
  def _search(a, {b}), do: __c(urn([a, @r[:action], {b}]), @r)
  def _search(a, b), do: __c(urn([a, b, @r[:action]]), @r)
  def _search({a}), do: __c(urn([@r[:action], {a}]), @r)
  def _search(a), do: __c(urn([a, @r[:action]]), @r)
  def _search(), do: __c(urn([@r[:action]]), @r)
end
