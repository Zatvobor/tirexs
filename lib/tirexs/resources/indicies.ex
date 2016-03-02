defmodule Tirexs.Resources.Indicies do
  @moduledoc false

  import Tirexs.Resources, only: [urn: 1, urn: 2, urn: 3, urn: 4, __c: 2]


  ## Mapping Management

  @doc false
  @r [action: "/_mapping", bump: :put, bump!: :put!]
  def _mapping(a, b, c), do: __c(urn(a, @r[:action], b, c), @r)
  def _mapping(a, b), do: __c(urn(a, @r[:action], b), @r)
  def _mapping({a}), do: __c(urn(@r[:action], {a}), @r)
  def _mapping(a), do: __c(urn(a, @r[:action]), @r)
  def _mapping(), do: __c(urn(@r[:action]), @r)

  @doc false
  def _all_mapping(), do: _mapping("_all")

  @doc false
  @r [action: "/_mapping/field", bump: :get, bump!: :get!]
  def _field_mapping(a, b, c, {d}), do: __c(urn([a, "_mapping", b, "field", c, {d}]), @r)
  def _field_mapping(a, b, c), do: __c(urn([a, "_mapping", b, "field", c]), @r)
  def _field_mapping(a, {b}), do: __c(urn(@r[:action], a, {b}), @r)
  def _field_mapping(a, b), do: __c(urn(a, @r[:action], b), @r)
  def _field_mapping(a), do: __c(urn(a, @r[:action]), @r)


  ## Index Settings

  @doc false
  @r [action: "/_analyze", bump: :get, bump!: :get!]
  def _analyze(a, b, c), do: __c(urn(a, @r[:action], b, c), @r)
  def _analyze(a, b), do: __c(urn(a, @r[:action], b), @r)
  def _analyze({a}), do: __c(urn(@r[:action], {a}), @r)
  def _analyze(a), do: __c(urn(a, @r[:action]), @r)
  def _analyze(), do: __c(urn(@r[:action]), @r)

  @doc false
  @r [action: "/_warmer", bump: :put, bump!: :put!]
  def _warmer(a, b, c), do: __c(urn(a, @r[:action], b, c), @r)
  def _warmer(a, b), do: __c(urn(a, @r[:action], b), @r)
  def _warmer({a}), do: __c(urn(@r[:action], {a}), @r)
  def _warmer(a), do: __c(urn(a, @r[:action]), @r)
  def _warmer(), do: __c(urn(@r[:action]), @r)

  @doc false
  @r [action: "/_template", bump: :put, bump!: :put!]
  def _template(a, b, c), do: __c(urn(a, @r[:action], b, c), @r)
  def _template(a, b), do: __c(urn(a, @r[:action], b), @r)
  def _template({a}), do: __c(urn(@r[:action], {a}), @r)
  def _template(a), do: __c(urn(a, @r[:action]), @r)
  def _template(), do: __c(urn(@r[:action]), @r)

  @doc false
  @r [action: "/_settings", bump: :get, bump!: :get!]
  def _settings(a, b, c), do: __c(urn(a, @r[:action], b, c), @r)
  def _settings(a, b), do: __c(urn(a, @r[:action], b), @r)
  def _settings({a}), do: __c(urn(@r[:action], {a}), @r)
  def _settings(a), do: __c(urn(a, @r[:action]), @r)
  def _settings(), do: __c(urn(@r[:action]), @r)


  ## Index Management

  @doc false
  @r [action: "/_open", bump: :post, bump!: :post!]
  def _open(a, b, c), do: __c(urn(a, @r[:action], b, c), @r)
  def _open(a, b), do: __c(urn(a, @r[:action], b), @r)
  def _open({a}), do: __c(urn(@r[:action], {a}), @r)
  def _open(a), do: __c(urn(a, @r[:action]), @r)
  def _open(), do: __c(urn(@r[:action]), @r)

  @doc false
  @r [action: "/_close", bump: :post, bump!: :post!]
  def _close(a, b, c), do: __c(urn(a, @r[:action], b, c), @r)
  def _close(a, b), do: __c(urn(a, @r[:action], b), @r)
  def _close({a}), do: __c(urn(@r[:action], {a}), @r)
  def _close(a), do: __c(urn(a, @r[:action]), @r)
  def _close(), do: __c(urn(@r[:action]), @r)


  ## Alias Management

  @doc false
  @r [action: "/_aliases"]
  def _aliases(a, b, c), do: __c(urn(a, @r[:action], b, c), @r)
  def _aliases(a, b), do: __c(urn(a, @r[:action], b), @r)
  def _aliases({a}), do: __c(urn(@r[:action], {a}), @r)
  def _aliases(a), do: __c(urn(a, @r[:action]), @r)
  def _aliases(), do: __c(urn(@r[:action]), @r)

  @doc false
  @r [action: "/_alias", bump: :put, bump!: :put!]
  def _alias(a, b, c), do: __c(urn(a, @r[:action], b, c), @r)
  def _alias(a, b), do: __c(urn(a, @r[:action], b), @r)
  def _alias({a}), do: __c(urn(@r[:action], {a}), @r)
  def _alias(a), do: __c(urn(a, @r[:action]), @r)
  def _alias(), do: __c(urn(@r[:action]), @r)


  ## Status Management

  @doc false
  @r [action: "/_refresh", bump: :post, bump!: :post!]
  def _refresh(a, b, c), do: __c(urn(a, @r[:action], b, c), @r)
  def _refresh(a, b), do: __c(urn(a, @r[:action], b), @r)
  def _refresh({a}), do: __c(urn(@r[:action], {a}), @r)
  def _refresh(a), do: __c(urn(a, @r[:action]), @r)
  def _refresh(), do: __c(urn(@r[:action]), @r)

  @doc false
  @r [action: "/_flush", bump: :post, bump!: :post!]
  def _flush(a, b, c), do: __c(urn(a, @r[:action], b, c), @r)
  def _flush(a, b), do: __c(urn(a, @r[:action], b), @r)
  def _flush({a}), do: __c(urn(@r[:action], {a}), @r)
  def _flush(a), do: __c(urn(a, @r[:action]), @r)
  def _flush(), do: __c(urn(@r[:action]), @r)

  @doc false
  @r [action: "/_forcemerge", bump: :post, bump!: :post!]
  def _forcemerge(a, b, c), do: __c(urn(a, @r[:action], b, c), @r)
  def _forcemerge(a, b), do: __c(urn(a, @r[:action], b), @r)
  def _forcemerge({a}), do: __c(urn(@r[:action], {a}), @r)
  def _forcemerge(a), do: __c(urn(a, @r[:action]), @r)
  def _forcemerge(), do: __c(urn(@r[:action]), @r)

  @doc false
  @r [action: "/_upgrade", bump: :post, bump!: :post!]
  def _upgrade(a, b, c), do: __c(urn(a, @r[:action], b, c), @r)
  def _upgrade(a, b), do: __c(urn(a, @r[:action], b), @r)
  def _upgrade({a}), do: __c(urn(@r[:action], {a}), @r)
  def _upgrade(a), do: __c(urn(a, @r[:action]), @r)
  def _upgrade(), do: __c(urn(@r[:action]), @r)

  @doc false
  @r [action: "/_cache/clear", bump: :post, bump!: :post!]
  def _cache_clear(a, b, c), do: __c(urn(a, @r[:action], b, c), @r)
  def _cache_clear({a}), do: __c(urn(@r[:action], {a}), @r)
  def _cache_clear(a), do: __c(urn(a, @r[:action]), @r)
  def _cache_clear(), do: __c(urn(@r[:action]), @r)


  ## Monitoring Management

  @doc false
  @r [action: "/_stats", bump: :get, bump!: :get!]
  def _stats(a, b, c), do: __c(urn(a, @r[:action], b, c), @r)
  def _stats(a, b), do: __c(urn(a, @r[:action], b), @r)
  def _stats({a}), do: __c(urn(@r[:action], {a}), @r)
  def _stats(a), do: __c(urn(a, @r[:action]), @r)
  def _stats(), do: __c(urn(@r[:action]), @r)

  @doc false
  @r [action: "/_segments", bump: :get, bump!: :get!]
  def _segments(a, b, c), do: __c(urn(a, @r[:action], b, c), @r)
  def _segments(a, b), do: __c(urn(a, @r[:action], b), @r)
  def _segments({a}), do: __c(urn(@r[:action], {a}), @r)
  def _segments(a), do: __c(urn(a, @r[:action]), @r)
  def _segments(), do: __c(urn(@r[:action]), @r)

  @doc false
  @r [action: "/_recovery", bump: :get, bump!: :get!]
  def _recovery(a, b, c), do: __c(urn(a, @r[:action], b, c), @r)
  def _recovery(a, b), do: __c(urn(a, @r[:action], b), @r)
  def _recovery({a}), do: __c(urn(@r[:action], {a}), @r)
  def _recovery(a), do: __c(urn(a, @r[:action]), @r)
  def _recovery(), do: __c(urn(@r[:action]), @r)

  @doc false
  @r [action: "/_shard_stores", bump: :get, bump!: :get!]
  def _shard_stores(a, b, c), do: __c(urn(a, @r[:action], b, c), @r)
  def _shard_stores(a, b), do: __c(urn(a, @r[:action], b), @r)
  def _shard_stores({a}), do: __c(urn(@r[:action], {a}), @r)
  def _shard_stores(a), do: __c(urn(a, @r[:action]), @r)
  def _shard_stores(), do: __c(urn(@r[:action]), @r)
end
