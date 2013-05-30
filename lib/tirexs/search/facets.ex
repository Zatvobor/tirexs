defmodule Tirexs.Search.Facets do
  @moduledoc false

  use Tirexs.DSL.Logic

  alias Tirexs.Query, as: Query

  def transpose(block) do
    case block do
      {:terms, _, [params]}           -> terms(params)
      {:range, _, [params]}           -> range(params)
      {:histogram, _, [params]}       -> histogram(params)
      {:date_histogram, _, [params]}  -> date_histogram(params)
      {:statistical, _, [params]}     -> statistical(params)
      {:terms_stats, _, [params]}     -> terms_stats(params)
      {:geo_distance, _, [params]}    -> geo_distance(params)
      {:facet_filter, _, [params]}    -> Query.facet_filter(params[:do])
      {:facet_filter, _, options}     -> Query.facet_filter(options)
      {name, _, [params]}             -> make_facet(name, params[:do])
      {name, _, params}               -> make_facet(name, params)
    end
  end


  defmacro facets([do: block]) do
    [facets: extract(block)]
  end

  def _facets(block) do
    [facets: extract(block)]
  end

  def make_facet(name, options, facet_opts//[]) do
    if is_list(options) do
      facet_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
    routers(name, options, facet_opts)
  end

  def terms(options) do
    [terms: options]
  end

  def terms(options, [do: block]) do
    [terms: options ++ block[:do]]
  end

  def range(options) do
    [range: options]
  end

  def histogram(options) do
    [histogram: options]
  end

  def date_histogram(options) do
    [date_histogram: options]
  end

  def statistical(options) do
    [statistical: options]
  end

  def terms_stats(options) do
    [terms_stats: options]
  end

  def geo_distance(options) do
    [geo_distance: options]
  end

  defp routers(name, options, add_options) do
    case options do
      {:filter, _, [params]}        -> Tirexs.Query.Filter._filter(params[:do])
      {:query, _, [params]}         -> Tirexs.Query._query(params[:do])
      options                       -> Dict.put([], to_atom(name), extract(options) ++ add_options)
    end
  end

end