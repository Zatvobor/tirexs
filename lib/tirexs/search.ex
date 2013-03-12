defmodule Tirexs.Search do

  import Tirexs.Search.Helpers

  defmacro search([do: block]) do
    [search: extract(block)]
  end

  defmacro search(options, [do: block]) do
    [search: extract(block) ++ options]
  end

  def filters(params, _opts) do
    [filter: params]
  end

  def highlight([do: block]) do
    [highlight: block]
  end

  def sort([do: block]) do
    [sort: block]
  end

  def script_fields([do: block]) do
    [script_fields: block]
  end

end