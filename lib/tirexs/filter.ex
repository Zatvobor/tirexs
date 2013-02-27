defmodule Tirexs.Filter do

  import Tirexs.Query.Helpers
  import Tirexs.Helpers

  defmacro __using__(_) do
    quote do
      import unquote(Tirexs.Filter)
    end
  end

  defmacro filter([do: block]) do
    [filter: extract(block)]
  end

  def _filter(options, filter_opts//[]) do
    if is_list(options) do
      filter_opts = Enum.at!(options, 0)
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

  def _not(options, not_opts//[]) do
    if is_list(options) do
      not_opts = Enum.at!(options, 0)
      options = extract_do(options, 1)
    end
    [not: extract(options) ++ not_opts]
  end

  def numeric_range(options) do
    [field, value, _] = extract_options(options)
    [numeric_range: Dict.put([], to_atom(field), value)]
  end

  def fquery(options, fquery_opts//[]) do
    if is_list(options) do
      fquery_opts = Enum.at!(options, 0)
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

  def _and(options, and_opts//[]) do
    if is_list(options) do
      and_opts = Enum.at!(options, 0)
      options = extract_do(options, 1)
    end
    [and: extract(options) ++ and_opts]
  end

  def _or(options, or_opts//[]) do
    if is_list(options) do
      or_opts = Enum.at!(options, 0)
      options = extract_do(options, 1)
    end
    [or: extract(options) ++ or_opts]
  end

end