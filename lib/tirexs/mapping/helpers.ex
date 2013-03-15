defmodule Tirexs.Mapping.Helpers do

  import Tirexs.DSL.Logic
  use Tirexs.DSL.Logic

  defoverridable [transpose: 1]

  defp transpose(block) do
    case block do
      {:indexes, _, [params]}  -> Tirexs.Mapping.indexes(params[:do])
      {:indexes, _, options}   -> Tirexs.Mapping.indexes(options)
      {:index, _, [params]}    -> Tirexs.Mapping.indexes(params[:do])
      {:index, _, options}     -> Tirexs.Mapping.indexes(options)

      _                        -> IO.puts inspect(block)
    end
  end

end