defmodule Tirexs.Resources.Document do
  @moduledoc """
  Provides URN builders for document APIs.

  `Tirexs.Resources.APIs` describes the main interface and available options.

  """

  import Tirexs.Resources, only: [urn: 1, __c: 2]


  @doc false
  @r [bump: :get, bump!: :get!]
  def index(a, b, c, d), do: __c(urn([a, b, c, d]), @r)
  def index(a, b, c), do: __c(urn([a, b, c]), @r)
  def index(a, b), do: __c(urn([a, b]), @r)
  def index(a), do: __c(urn([a]), @r)
  
  @doc false
  @r [bump: :get, bump!: :get!]
  def doc(a, b, c, d), do: __c(urn([a, b, c, d]), @r)
  def doc(a, b, c), do: __c(urn([a, b, c]), @r)
  def doc(a, b), do: __c(urn([a, b]), @r)
  def doc(a), do: __c(urn([a]), @r)

  @doc false
  @r [action: "/_bulk", bump: :post, bump!: :post!]
  def _bulk(a, b, c), do: __c(urn([a, b, @r[:action], c]), @r)
  def _bulk(a, {b}), do: __c(urn([a, @r[:action], {b}]), @r)
  def _bulk(a, b), do: __c(urn([a, b, @r[:action]]), @r)
  def _bulk({a}), do: __c(urn([@r[:action], {a}]), @r)
  def _bulk(a), do: __c(urn([a, @r[:action]]), @r)
  def _bulk(), do: __c(urn([@r[:action]]), @r)

  @doc false
  @r [action: "/_source", bump: :get, bump!: :get!]
  def _source(a, b, c, d), do: __c(urn([a, b, c, @r[:action], d]), @r)
  def _source(a, b, c), do: __c(urn([a, b, c, @r[:action]]), @r)
  def _source(a, {b}), do: __c(urn([a, @r[:action], {b}]), @r)
  def _source(a), do: __c(urn([a, @r[:action]]), @r)
end
