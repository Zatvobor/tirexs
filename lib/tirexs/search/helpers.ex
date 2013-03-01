defmodule Tirexs.Search.Helpers do
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
      # {name, _, [params]} -> Tirexs.Facets.make_facet(name, params)
      {:query, _, [params]}     -> Tirexs.Query._query(params[:do])
      {:query, _, options}      -> Tirexs.Query._query(options)
      {:filter, _, [params]}    -> Tirexs.Filter._filter(params[:do])
      {:filter, _, options}     -> Tirexs.Filter._filter(options)
      {:facets, _, [params]}    -> Tirexs.Facets._facets(params[:do])
      {:highlight, _, [params]} -> Tirexs.Search.highlight(params)
      {:sort, _, [params]}      -> Tirexs.Search.sort(params)
      {:rescore, _, [params]}   -> Tirexs.Rescore._rescore(params[:do])
      {:rescore, _, options}   -> Tirexs.Rescore._rescore(options)
    end
  end

end