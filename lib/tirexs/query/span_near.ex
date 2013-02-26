defmodule Tirexs.Query.SpanNear do
  import Tirexs.Query.Helpers

  def clauses(options) do
    [clauses: to_array(scoped_query(options))]
  end
end