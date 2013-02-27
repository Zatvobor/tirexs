defmodule Tirexs.Filter do

  import Tirexs.Query.Helpers
  import Tirexs.Helpers

  defmacro __using__(_) do
    quote do
      import unquote(Tirexs.Filter)
    end
  end

  defmacro filter([do: block]) do
    [filter: scoped_query(block)]
  end

  def _filter(options, filter_opts//[]) do
    if is_list(options) do
      filter_opts = Enum.at!(options, 0)
      options = extract_do(options, 1)
    end
    [filter: scoped_query(options) ++ filter_opts]
  end

  def filtered(options) do
    [filtered: scoped_query(options)]
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
end