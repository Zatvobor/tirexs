defmodule Tirexs.Query.Filter do
  @moduledoc false

  import Tirexs.DSL.Logic
  import Tirexs.Query.Logic


  defmacro filter([do: block]) do
    [filter: extract(block)]
  end

  def _filter(options, filter_opts \\ []) do
    if is_list(options) do
      filter_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
    [filter: extract(options) ++ filter_opts]
  end

  def filtered(options) do
    [filtered: extract(options)]
  end

  def exists(options) do
    [value, _, _] = extract_options(options)
    [exists: [field: value]]
  end

  def limit(options) do
   [value, _, _] = extract_options(options)
   [limit: [value: value]]
  end

  def type(options) do
    [value, _, _] = extract_options(options)
    [type: [value: value]]
  end

  def missing(options) do
    [value, options, _] = extract_options(options)
    [missing: [field: value] ++ options]
  end

  def _not(options, not_opts \\ []) do
    if is_list(options) do
      not_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
    [not: extract(options) ++ not_opts]
  end

  def numeric_range(options) do
    [field, value, _] = extract_options(options)
    [numeric_range: Dict.put([], to_atom(field), value)]
  end

  def fquery(options, fquery_opts \\ []) do
    if is_list(options) do
      fquery_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
    [fquery: extract(options) ++ fquery_opts]
  end

  def script(options) do
    [script, params, _] = extract_options(options)
    [script: [script: script, params: params]]
  end

  def filters(block) do
    [filters: to_array(extract(block))]
  end

  def _and(options, and_opts \\ []) do
    if is_list(options) do
      and_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
    [and: extract(options) ++ and_opts]
  end

  def _or(options, or_opts \\ []) do
    if is_list(options) do
      or_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
    [or: extract(options) ++ or_opts]
  end

  def join(:and, filters) do
    [and: [filters: to_array(filters)]]
  end

  def join(:or, filters) do
    [or: [filters: to_array(filters)]]
  end

  def geo_bounding_box(options) do
    [field, value, options] = extract_options(options)
    [geo_bounding_box: Dict.put([], to_atom(field), value) ++ options]
  end

  def geo_distance(options) do
    [field, value, options] = extract_options(options)
    [geo_distance: Dict.put([], to_atom(field), value) ++ options]
  end

  def geo_distance_range(options) do
    [field, value, options] = extract_options(options)
    [geo_distance_range: Dict.put([], to_atom(field), value) ++ options]
  end

  def geo_polygon(options) do
    [field, value, options] = extract_options(options)
    [geo_polygon: Dict.put([], to_atom(field), [points: value]) ++ options]
  end
end