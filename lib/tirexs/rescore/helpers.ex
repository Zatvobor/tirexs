defmodule Tirexs.Rescore.Helpers do
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
      {:query, _, [params]} -> Tirexs.Query._query(params[:do])
      {:query, _, options}  -> Tirexs.Query._query(options)
      {:filter, _, [params]} -> Tirexs.Filter._filter(params[:do])
      {:filter, _, options}  -> Tirexs.Filter._filter(options)
    end
  end


end