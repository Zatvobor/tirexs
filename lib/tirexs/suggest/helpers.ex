defmodule Tirexs.Suggest.Helpers do
  import Tirexs.DSL.Logic
  use Tirexs.DSL.Logic

  defoverridable [transpose: 1]

  defp transpose(block) do
    case block do
      {:filter, _, [params]}          -> Tirexs.Filter._filter(params[:do])
      {:query, _, [params]}           -> Tirexs.Query._query(params[:do])
      {:fuzzy, _, params}             -> Tirexs.Query.fuzzy(params)
      {name, _, [params]}             -> Tirexs.Suggest.make_suggest(name, params[:do])
      {name, _, params}               -> Tirexs.Suggest.make_suggest(name, params)
    end
  end

end