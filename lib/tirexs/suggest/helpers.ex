defmodule Tirexs.Suggest.Helpers do
  import Tirexs.Helpers
  use Tirexs.Helpers

  defoverridable [routers: 1]

  defp routers(block) do
    case block do
      {:filter, _, [params]}          -> Tirexs.Filter._filter(params[:do])
      {:query, _, [params]}           -> Tirexs.Query._query(params[:do])
      {:fuzzy, _, params}          -> Tirexs.Query.fuzzy(params)
      {name, _, [params]}             -> Tirexs.Suggest.make_suggest(name, params[:do])
      {name, _, params}               -> Tirexs.Suggest.make_suggest(name, params)
    end
  end

end