defmodule Tirexs.Facets do
  import Tirexs.Helpers
  import Tirexs.Facets.Helpers

  defmacro __using__(_) do
    quote do
      import unquote(Tirexs.Facets)
    end
  end

  defmacro facets([do: block]) do
    [facets: extract(block)]
  end

  def make_facet(name, options) do
    routers(name, options)
    # Dict.put([], to_atom(name), routers(options))
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

  defp routers(name, options) do
    case options[:do] do
      {:filter, _, [params]} -> Tirexs.Filter._filter(params[:do])
      {:query, _, [params]} -> Tirexs.Query._query(params[:do])
      options -> Dict.put([], to_atom(name), options)
    end
  end

end