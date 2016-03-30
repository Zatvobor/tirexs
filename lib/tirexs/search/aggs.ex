defmodule Tirexs.Search.Aggs do
  @moduledoc """
  It helps provide aggregated data based on a search query. It is based on
  simple building blocks called aggregations, that can be composed
  in order to build complex summaries of the data.

  """

  use Tirexs.DSL.Logic
  alias Tirexs.{Query, Query.Filter}


  @doc false
  defmacro aggs([do: block]) do
    [aggs: extract(block)]
  end


  @doc false
  def transpose(block) do
    case block do
      {:term_stats, _, [a,b]}         -> term_stats(a, b)
      {:terms, _, [params]}           -> terms(params)
      {:stats, _, [params]}           -> stats(params)
      {:date_histogram, _, [params]}  -> date_histogram(params)
      {name, _, [params]}             -> _aggs(name, params[:do])
      {name, _, params}               -> _aggs(name, params)
    end
  end

  @doc false
  def term_stats(terms, stats) do
    [tags: [terms: terms, aggs: [{to_atom("#{stats[:field]}_stats"), [stats: stats]}]]]
  end

  @doc false
  def terms(terms) do
    [terms: terms]
  end

  @doc false
  def stats(stats) do
    [aggs: [{to_atom("#{stats[:field]}_stats"), [stats: stats]}]]
  end

  @doc false
  def date_histogram(options) do
    [date_histogram: options]
  end


  defp _aggs(name, params, add_options \\ []) do
    if is_list(params) do
      add_options = Enum.fetch!(params, 0)
      params = extract_do(params, 1)
    end
    routers(name, params, add_options)
  end

  defp routers(name, options, add_options) do
    case options do
      {:filter, _, [params]} -> [{to_atom(name), Filter._filter(params[:do])}]
      options                -> [{to_atom(name), extract(options) ++ add_options }]
    end
  end
end
