defmodule Tirexs.Resources.APIs do
  @moduledoc false


  alias Tirexs.Resources.Indicies


  ## Mapping Management

  @doc false
  defdelegate [ _all_mapping() ], to: Indicies
  defdelegate [ _mapping(), _mapping(a), _mapping(a, b), _mapping(a, b, c) ], to: Indicies
  defdelegate [ _field_mapping(a), _field_mapping(a, b), _field_mapping(a, b, c),  _field_mapping(a, b, c)], to: Indicies

  ## Index Settings

  @doc false
  defdelegate [ _analyze(), _analyze(a), _analyze(a, b), _analyze(a, b, c) ], to: Indicies
  defdelegate [ _warmer(), _warmer(a), _warmer(a, b), _warmer(a, b, c) ], to: Indicies
  defdelegate [ _template(), _template(a), _template(a, b), _template(a, b, c) ], to: Indicies
  defdelegate [ _settings(), _settings(a), _settings(a, b), _settings(a, b, c) ], to: Indicies

  ## Index Management

  @doc false
  defdelegate [ _open(), _open(a), _open(a, b), _open(a, b, c) ], to: Indicies
  defdelegate [ _close(), _close(a), _close(a, b), _close(a, b, c) ], to: Indicies
  ## Alias Management

  @doc false
  defdelegate [ _aliases(), _aliases(a), _aliases(a, b), _aliases(a, b, c) ], to: Indicies
  defdelegate [ _alias(), _alias(a), _alias(a, b), _alias(a, b, c) ], to: Indicies

  ## Status Management

  @doc false
  defdelegate [ _refresh(), _refresh(a), _refresh(a, b), _refresh(a, b, c) ], to: Indicies
  defdelegate [ _flush(), _flush(a), _flush(a, b), _flush(a, b, c) ], to: Indicies
  defdelegate [ _forcemerge(), _forcemerge(a), _forcemerge(a, b), _forcemerge(a, b, c) ], to: Indicies
  defdelegate [ _upgrade(), _upgrade(a), _upgrade(a, b), _upgrade(a, b, c) ], to: Indicies
  defdelegate [ _cache_clear(), _cache_clear(a), _cache_clear(a, b), _cache_clear(a, b, c) ], to: Indicies

  ## Monitoring Management

  @doc false
  defdelegate [ _stats(), _stats(a), _stats(a, b), _stats(a, b, c) ], to: Indicies
  defdelegate [ _segments(), _segments(a), _segments(a, b), _segments(a, b, c) ], to: Indicies
  defdelegate [ _recovery(), _recovery(a), _recovery(a, b), _recovery(a, b, c) ], to: Indicies
  defdelegate [ _shard_stores(), _shard_stores(a), _shard_stores(a, b), _shard_stores(a, b, c) ], to: Indicies
end
