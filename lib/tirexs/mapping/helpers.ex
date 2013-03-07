defmodule Tirexs.Mapping.Helpers do

  import Tirexs.Helpers
  use Tirexs.Helpers

  defoverridable [routers: 1]

  defp routers(block) do
    case block do
      {:indexes, _, [params]}  -> Tirexs.Mapping.indexes(params[:do])
      {:indexes, _, options}   -> Tirexs.Mapping.indexes(options)
      {:index, _, [params]}    -> Tirexs.Mapping.indexes(params[:do])
      {:index, _, options}     -> Tirexs.Mapping.indexes(options)

      _                        -> IO.puts inspect(block)
    end
  end

end