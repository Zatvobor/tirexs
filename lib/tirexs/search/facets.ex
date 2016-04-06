defmodule Tirexs.Search.Facets do
  @moduledoc "this module is deprecated in favor of `Tirexs.Search.Aggs`"

  use Tirexs.DSL.Logic

  @doc false
  defmacro facets([do: block]) do
    [facets: extract(block)]
  end


  alias Tirexs.{Query, Query.Filter}

  @doc false
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

  @doc false
  def _facets(block) do
    [facets: extract(block)]
  end

  @doc false
  def make_facet(name, options, facet_opts \\ []) do
    if is_list(options) do
      facet_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
    routers(name, options, facet_opts)
  end

  @doc false
  def terms(options) do
    [terms: options]
  end

  @doc false
  def terms(options, [do: block]) do
    [terms: options ++ block[:do]]
  end

  @doc false
  def range(options) do
    [range: options]
  end

  @doc false
  def histogram(options) do
    [histogram: options]
  end

  @doc false
  def date_histogram(options) do
    [date_histogram: options]
  end

  @doc false
  def statistical(options) do
    [statistical: options]
  end

  @doc false
  def terms_stats(options) do
    [terms_stats: options]
  end

  @doc false
  def geo_distance(options) do
    [geo_distance: options]
  end


  defp routers(name, options, add_options) do
    case options do
      {:filter, _, [params]}        -> Filter._filter(params[:do])
      {:query, _, [params]}         -> Query._query(params[:do])
      options                       -> Keyword.put([], to_atom(name), extract(options) ++ add_options)
    end
  end
end
