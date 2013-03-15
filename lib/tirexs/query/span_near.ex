defmodule Tirexs.Query.SpanNear do
  import Tirexs.Query.Helpers
  import Tirexs.DSL.Logic

  def clauses(options) do
    [clauses: to_array(extract(options))]
  end
end