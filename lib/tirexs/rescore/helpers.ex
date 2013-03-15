defmodule Tirexs.Rescore.Helpers do

  import Tirexs.DSL.Logic
  use Tirexs.DSL.Logic

  defoverridable [transpose: 1]

  defp transpose(block) do
    case block do
      {:query, _, [params]} -> Tirexs.Query._query(params[:do])
      {:query, _, options}  -> Tirexs.Query._query(options)
      {:filter, _, [params]} -> Tirexs.Filter._filter(params[:do])
      {:filter, _, options}  -> Tirexs.Filter._filter(options)
    end
  end


end