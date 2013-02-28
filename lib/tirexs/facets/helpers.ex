defmodule Tirexs.Facets.Helpers do
  import Tirexs.Helpers

  def extract(block) do
    extract(get_clear_block(block), [])
  end

  defp extract([], acc) do
    acc
  end

  defp extract([h|t], acc) do
    extract(get_clear_block(t), acc ++ routers(h))
  end

  defp extract(item, acc) do
    acc ++ routers(item)
  end

  defp routers(block) do
    case block do
      {name, _, [params]} -> Tirexs.Facets.make_facet(name, params)
    end
  end


end