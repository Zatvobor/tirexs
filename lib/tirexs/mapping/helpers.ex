defmodule Tirexs.Mapping.Helpers do

  use Tirexs.DSL.Logic


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