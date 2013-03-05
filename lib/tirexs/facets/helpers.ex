defmodule Tirexs.Facets.Helpers do
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
      {:terms, _, [params]}           -> Tirexs.Facets.terms(params)
      {:range, _, [params]}           -> Tirexs.Facets.range(params)
      {:histogram, _, [params]}       -> Tirexs.Facets.histogram(params)
      {:date_histogram, _, [params]}  -> Tirexs.Facets.date_histogram(params)
      {:statistical, _, [params]}     -> Tirexs.Facets.statistical(params)
      {:terms_stats, _, [params]}     -> Tirexs.Facets.terms_stats(params)
      {:geo_distance, _, [params]}    -> Tirexs.Facets.geo_distance(params)
      {:facet_filter, _, [params]}    -> Tirexs.Query.facet_filter(params[:do])
      {:facet_filter, _, options}     -> Tirexs.Query.facet_filter(options)
      {name, _, [params]}             -> Tirexs.Facets.make_facet(name, params[:do])
      {name, _, params}               -> Tirexs.Facets.make_facet(name, params)
    end
  end

end