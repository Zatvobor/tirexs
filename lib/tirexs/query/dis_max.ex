defmodule Tirexs.Query.DisMax do
  import Tirexs.Query.Helpers
  import Tirexs.DSL.Logic

  def queries(options) do
    [queries: to_array(extract(options))]
  end
end