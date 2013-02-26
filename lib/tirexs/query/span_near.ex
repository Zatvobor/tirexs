defmodule Tirexs.Query.SpanNear do
  import Tirexs.Query.Helpers
  import Tirexs.Helpers

  def clauses(options) do
    [clauses: to_array(scoped_query(options))]
  end
end