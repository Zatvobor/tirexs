defmodule Tirexs.Query.Bootstring do

  import Tirexs.Query.Helpers
  import Tirexs.Helpers

  def positive(options) do
    [positive: extract(extract_do(options))]
  end

  def negative(options) do
    [negative: extract(extract_do(options))]
  end

end