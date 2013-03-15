defmodule Tirexs.Warmer.Helpers do
  import Tirexs.DSL.Logic
  use Tirexs.DSL.Logic

  defoverridable [transpose: 1]

  defp transpose(block) do
    case block do
      {:filter, _, [params]}          -> Tirexs.Filter._filter(params[:do])
      {:query, _, [params]}           -> Tirexs.Query._query(params[:do])
      {:facets, _, [params]}          -> Tirexs.Facets._facets(params[:do])
      {name, _, [params]}             -> Tirexs.Warmer.make_warmer(name, params[:do])
      {name, _, params}               -> Tirexs.Warmer.make_warmer(name, params)
    end
  end

end