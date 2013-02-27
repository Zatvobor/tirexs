defmodule Tirexs.Query.Bootstring do

  import Tirexs.Query.Helpers
  import Tirexs.Helpers

  def positive(options) do
    [positive: scoped_query(extract_do(options))]
  end

  def negative(options) do
    [negative: scoped_query(extract_do(options))]
  end

end