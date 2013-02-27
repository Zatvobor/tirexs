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

  def exists(options) do
    [value, _, _] = extract_options(options)
    [exists: [field: value]]
  end
end