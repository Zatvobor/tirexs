defmodule Tirexs.Search do
  @moduledoc false

  use Tirexs.DSL.Logic

  def transpose(block) do
    case block do
      {:query, _, [params]}         -> Tirexs.Query._query(params[:do])
      {:query, _, options}          -> Tirexs.Query._query(options)
      {:filter, _, [params]}        -> Tirexs.Query.Filter._filter(params[:do])
      {:filter, _, options}         -> Tirexs.Query.Filter._filter(options)
      {:facets, _, [params]}        -> Tirexs.Search.Facets._facets(params[:do])
      {:highlight, _, [params]}     -> highlight(params)
      {:sort, _, [params]}          -> sort(params)
      {:script_fields, _, [params]} -> script_fields(params)
      {:suggest, _, [params]}       -> Tirexs.Search.Suggest._suggest(params[:do])
      {:suggest, _, options}        -> Tirexs.Search.Suggest._suggest(options)
      {:rescore, _, [params]}       -> Tirexs.Search.Rescore._rescore(params[:do])
      {:rescore, _, options}        -> Tirexs.Search.Rescore._rescore(options)
      {:filters, _, [options]}      -> Tirexs.Search.filters(options, [])
    end
  end


  defmacro search([do: block]) do
    [search: extract(block)]
  end

  defmacro search(options, [do: block]) do
    [search: extract(block) ++ options]
  end

  def filters(params, _opts) do
    [filter: params]
  end

  def highlight([do: block]) do
    [highlight: block]
  end

  def sort([do: block]) do
    [sort: block]
  end

  def script_fields([do: block]) do
    [script_fields: block]
  end
end