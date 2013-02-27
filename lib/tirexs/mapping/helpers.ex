defmodule Tirexs.Mapping.Helpers do

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
      {:indexes, _, [params]}  -> Tirexs.Mapping.indexes(params[:do])
      {:indexes, _, options}   -> Tirexs.Mapping.indexes(options)

      _                        -> IO.puts inspect(block)
    end
  end

end