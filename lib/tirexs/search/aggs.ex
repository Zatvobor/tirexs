defmodule Tirexs.Search.Aggs do
  @moduledoc """
  It helps provide aggregated data based on a search query. It is based on
  simple building blocks called aggregations, that can be composed
  in order to build complex summaries of the data.

  """

  use Tirexs.DSL.Logic
  alias Tirexs.{Query.Filter}


  @doc false
  defmacro aggs([do: block]) do
    [aggs: extract(block)]
  end


  @doc false
  def transpose(block) do
    case block do
      {:term_stats, _, [a,b]}         -> term_stats(a, b)
      {:terms, _, [params]}           -> terms(params)
      {:term, _, [field, value]}      -> term(field, value)
      {:stats, _, [params]}           -> stats(params)
      {:histogram, _, [params]}       -> histogram(params)
      {:date_histogram, _, [params]}  -> date_histogram(params)
      {:geo_distance, _, [params]}    -> geo_distance(params)
      {:range, _, [params]}           -> range(params)
      {:nested, _, [params]}          -> nested(params)
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
  def term(field, value) do
    [term: [{to_atom(field), value}]]
  end

  @doc false
  def stats(stats) do
    [aggs: [{to_atom("#{stats[:field]}_stats"), [stats: stats]}]]
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
  def geo_distance(options) do
    [geo_distance: options]
  end

  @doc false
  def range(options) do
    [range: options]
  end

  @doc false
  def nested(params) do
    [nested: params]
  end

  @doc false
  def _aggs(params) when is_tuple(params) do
    routers(:aggs, params)
  end


  defp _aggs(name, params) when is_tuple(params) do
    routers(name, params)
  end

  defp routers(name, body) when is_tuple(body) do
    case body do
      {:__block__, _, params}   -> [ {to_atom(name), extract(params)} ]
      {:filter, _, [params]}    -> [ {to_atom(name), Filter._filter(params[:do])} ]
      _                         -> [ {to_atom(name), extract(body)} ]
    end
  end
end
