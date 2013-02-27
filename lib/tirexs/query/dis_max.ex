defmodule Tirexs.Query.DisMax do
  import Tirexs.Query.Helpers
  import Tirexs.Helpers

  def queries(options) do
    [queries: to_array(scoped_query(options))]
  end
end