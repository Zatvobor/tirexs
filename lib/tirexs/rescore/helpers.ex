defmodule Tirexs.Rescore.Helpers do
  import Tirexs.Helpers
  use Tirexs.Helpers

  defoverridable [routers: 1]

  defp routers(block) do
    case block do
      {:query, _, [params]} -> Tirexs.Query._query(params[:do])
      {:query, _, options}  -> Tirexs.Query._query(options)
      {:filter, _, [params]} -> Tirexs.Filter._filter(params[:do])
      {:filter, _, options}  -> Tirexs.Filter._filter(options)
    end
  end


end