defmodule Tirexs.Query.Filter do
  @moduledoc false

  import Tirexs.DSL.Logic
  import Tirexs.Query.Logic


  @doc false
  defmacro filter([do: block]) do
    [filter: extract(block)]
  end

  @doc false
  def _filter(options, filter_opts \\ []) do
    if is_list(options) do
      filter_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
    [filter: extract(options) ++ filter_opts]
  end

  @doc false
  def filtered(options) do
    [filtered: extract(options)]
  end

  @doc false
  def exists(options) do
    [value, _, _] = extract_options(options)
    [exists: [field: value]]
  end

  @doc false
  def limit(options) do
   [value, _, _] = extract_options(options)
   [limit: [value: value]]
  end

  @doc false
  def type(options) do
    [value, _, _] = extract_options(options)
    [type: [value: value]]
  end

  @doc false
  def missing(options) do
    [value, options, _] = extract_options(options)
    [missing: [field: value] ++ options]
  end

  @doc false
  def _not(options, not_opts \\ []) do
    if is_list(options) do
      not_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
    [not: extract(options) ++ not_opts]
  end

  @doc false
  def numeric_range(options) do
    [field, value, _] = extract_options(options)
    [numeric_range: Keyword.put([], to_atom(field), value)]
  end

  @doc false
  def fquery(options, fquery_opts \\ []) do
    if is_list(options) do
      fquery_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
    [fquery: extract(options) ++ fquery_opts]
  end

  @doc false
  def script(options) do
    [script, params, _] = extract_options(options)
    [script: [script: script, params: params]]
  end

  @doc false
  def filters(block) do
    [filters: to_array(extract(block))]
  end

  @doc false
  def _and(options, and_opts \\ []) do
    if is_list(options) do
      and_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
    [and: extract(options) ++ and_opts]
  end

  @doc false
  def _or(options, or_opts \\ []) do
    if is_list(options) do
      or_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
    [or: extract(options) ++ or_opts]
  end

  @doc false
  def join(:and, filters) do
    [and: [filters: to_array(filters)]]
  end

  @doc false
  def join(:or, filters) do
    [or: [filters: to_array(filters)]]
  end

  @doc false
  def geo_bounding_box(options) do
    [field, value, options] = extract_options(options)
    [geo_bounding_box: Keyword.put([], to_atom(field), value) ++ options]
  end

  @doc false
  def geo_distance(options) do
    [field, value, options] = extract_options(options)
    [geo_distance: Keyword.put([], to_atom(field), value) ++ options]
  end

  @doc false
  def geo_distance_range(options) do
    [field, value, options] = extract_options(options)
    [geo_distance_range: Keyword.put([], to_atom(field), value) ++ options]
  end

  @doc false
  def geo_polygon(options) do
    [field, value, options] = extract_options(options)
    [geo_polygon: Keyword.put([], to_atom(field), [points: value]) ++ options]
  end
end
