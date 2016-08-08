defmodule Tirexs.Resources.APIs do
  @moduledoc """
  This module provides a set of API helpers. Helpers are useful for buiding
  an URN part of particular request. Most commonly the result of this would
  be used for dealing directly with variety of available `Tirexs.HTTP` functions.

  ## Examples:

      iex> APIs._refresh({ [force: true] })
      "_refresh?force=true"

      iex> APIs._refresh(["bear_test", "duck_test"], { [force: false] })
      "bear_test,duck_test/_refresh?force=false"

      iex> APIs._field_mapping(["bear_test", "duck_test"], "message", {[ ignore_unavailable: true ]})
      "bear_test,duck_test/_mapping/message/field?ignore_unavailable=true"

      iex> APIs._field_mapping("_all", "tw*", ["*.id", "*.text"])
      "_all/_mapping/tw*/field/*.id,*.text"

  NOTICE: All of helpers have the same interface, behaviour and almost don't care about the details.
  It means, you have a chance to create a complety unsupported API call.

  ## For instance:

      iex> APIs._refresh(["bear_test", "duck_test"], ["a", "b"], {[ human: true ]})
      "bear_test,duck_test/_refresh/a,b?human=true"


  A `Tirexs.Resources.urn/x` is responsible for concatenation parts all together.

  ## Feature requests

  Feature requests are welcome and should be discussed. But take a moment to find
  out whether your idea fits with the scope and aims of the project. Please provide
  as much detail and context as possible (from `CONTRIBUTING.md`).

  """

  alias Tirexs.Resources.Document

  defdelegate _bulk(), to: Document
  defdelegate _bulk(a), to: Document
  defdelegate _bulk(a,b), to: Document
  defdelegate _bulk(a,b,c), to: Document

  defdelegate _mget(), to: Document
  defdelegate _mget(a), to: Document
  defdelegate _mget(a,b), to: Document
  defdelegate _mget(a,b,c), to: Document

  defdelegate _source(a), to: Document
  defdelegate _source(a,b), to: Document
  defdelegate _source(a,b,c), to: Document
  defdelegate _source(a,b,c,d), to: Document

  defdelegate _update(a), to: Document
  defdelegate _update(a,b), to: Document
  defdelegate _update(a,b,c), to: Document
  defdelegate _update(a,b,c,d), to: Document

  defdelegate index(a), to: Document
  defdelegate index(a,b), to: Document
  defdelegate index(a,b,c), to: Document
  defdelegate index(a,b,c,d), to: Document

  defdelegate doc(a), to: Document
  defdelegate doc(a,b), to: Document
  defdelegate doc(a,b,c), to: Document
  defdelegate doc(a,b,c,d), to: Document


  alias Tirexs.Resources.Search

  defdelegate _explain(a), to: Search
  defdelegate _explain(a,b), to: Search
  defdelegate _explain(a,b,c), to: Search
  defdelegate _explain(a,b,c,d), to: Search

  defdelegate _search_shards(a), to: Search
  defdelegate _search_shards(a,b), to: Search
  defdelegate _search_shards(a,b,c), to: Search

  defdelegate _field_stats(), to: Search
  defdelegate _field_stats(a), to: Search
  defdelegate _field_stats(a,b), to: Search

  defdelegate _validate_query(), to: Search
  defdelegate _validate_query(a), to: Search
  defdelegate _validate_query(a,b), to: Search
  defdelegate _validate_query(a,b,c), to: Search

  defdelegate _count(), to: Search
  defdelegate _count(a), to: Search
  defdelegate _count(a,b), to: Search
  defdelegate _count(a,b,c), to: Search

  defdelegate _search_exists(), to: Search
  defdelegate _search_exists(a), to: Search
  defdelegate _search_exists(a,b), to: Search
  defdelegate _search_exists(a,b,c), to: Search

  defdelegate _search(), to: Search
  defdelegate _search(a), to: Search
  defdelegate _search(a,b), to: Search
  defdelegate _search(a,b,c), to: Search

  defdelegate _search_scroll(), to: Search
  defdelegate _search_scroll(a), to: Search

  defdelegate _search_scroll_all(), to: Search

  defdelegate percolator(a,b), to: Search

  defdelegate _percolate(a), to: Search
  defdelegate _percolate(a,b), to: Search
  defdelegate _percolate(a,b,c), to: Search
  defdelegate _percolate(a,b,c,d), to: Search

  defdelegate _percolate_count(a), to: Search
  defdelegate _percolate_count(a,b), to: Search
  defdelegate _percolate_count(a,b,c), to: Search
  defdelegate _percolate_count(a,b,c,d), to: Search


  alias Tirexs.Resources.Indices

  ## Mapping Management

  defdelegate _all_mapping(), to: Indices

  defdelegate _mapping(), to: Indices
  defdelegate _mapping(a), to: Indices
  defdelegate _mapping(a,b), to: Indices
  defdelegate _mapping(a,b,c), to: Indices

  defdelegate _field_mapping(a), to: Indices
  defdelegate _field_mapping(a,b), to: Indices
  defdelegate _field_mapping(a,b,c,d), to: Indices

  ## Index Settings

  defdelegate _analyze(), to: Indices
  defdelegate _analyze(a), to: Indices
  defdelegate _analyze(a,b), to: Indices
  defdelegate _analyze(a,b,c), to: Indices

  defdelegate _warmer(), to: Indices
  defdelegate _warmer(a), to: Indices
  defdelegate _warmer(a,b), to: Indices
  defdelegate _warmer(a,b,c), to: Indices

  defdelegate _template(), to: Indices
  defdelegate _template(a), to: Indices
  defdelegate _template(a,b), to: Indices
  defdelegate _template(a,b,c), to: Indices

  defdelegate _settings(), to: Indices
  defdelegate _settings(a), to: Indices
  defdelegate _settings(a,b), to: Indices
  defdelegate _settings(a,b,c), to: Indices

  ## Index Management

  defdelegate _open(), to: Indices
  defdelegate _open(a), to: Indices
  defdelegate _open(a,b), to: Indices
  defdelegate _open(a,b,c), to: Indices

  defdelegate _close(), to: Indices
  defdelegate _close(a), to: Indices
  defdelegate _close(a,b), to: Indices
  defdelegate _close(a,b,c), to: Indices

  ## Alias Management

  defdelegate _aliases(), to: Indices
  defdelegate _aliases(a), to: Indices
  defdelegate _aliases(a,b), to: Indices
  defdelegate _aliases(a,b,c), to: Indices

  defdelegate _alias(), to: Indices
  defdelegate _alias(a), to: Indices
  defdelegate _alias(a,b), to: Indices
  defdelegate _alias(a,b,c), to: Indices

  ## Status Management

  defdelegate _refresh(), to: Indices
  defdelegate _refresh(a), to: Indices
  defdelegate _refresh(a,b), to: Indices
  defdelegate _refresh(a,b,c), to: Indices

  defdelegate _flush(), to: Indices
  defdelegate _flush(a), to: Indices
  defdelegate _flush(a,b), to: Indices
  defdelegate _flush(a,b,c), to: Indices

  defdelegate _forcemerge(), to: Indices
  defdelegate _forcemerge(a), to: Indices
  defdelegate _forcemerge(a,b), to: Indices
  defdelegate _forcemerge(a,b,c), to: Indices

  defdelegate _upgrade(), to: Indices
  defdelegate _upgrade(a), to: Indices
  defdelegate _upgrade(a,b), to: Indices
  defdelegate _upgrade(a,b,c), to: Indices

  defdelegate _cache_clear(), to: Indices
  defdelegate _cache_clear(a), to: Indices
  defdelegate _cache_clear(a,b), to: Indices
  defdelegate _cache_clear(a,b,c), to: Indices

  ## Monitoring Management

  defdelegate _stats(), to: Indices
  defdelegate _stats(a), to: Indices
  defdelegate _stats(a,b), to: Indices
  defdelegate _stats(a,b,c), to: Indices

  defdelegate _segments(), to: Indices
  defdelegate _segments(a), to: Indices
  defdelegate _segments(a,b), to: Indices
  defdelegate _segments(a,b,c), to: Indices

  defdelegate _recovery(), to: Indices
  defdelegate _recovery(a), to: Indices
  defdelegate _recovery(a,b), to: Indices
  defdelegate _recovery(a,b,c), to: Indices

  defdelegate _shard_stores(), to: Indices
  defdelegate _shard_stores(a), to: Indices
  defdelegate _shard_stores(a,b), to: Indices
  defdelegate _shard_stores(a,b,c), to: Indices
end
