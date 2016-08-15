defmodule Tirexs.Search.Warmer do
  @moduledoc false

  use Tirexs.DSL.Logic


  defmacro warmers([do: block]) do
    [warmers: extract(block)]
  end


  alias Tirexs.{Query, Query.Filter, Search.Aggs}

  def transpose(block) do
    case block do
      {:filter, _, [params]}  -> Filter._filter(params[:do])
      {:query, _, [params]}   -> Query._query(params[:do])
      {:aggs, _, [params]}    -> Aggs._aggs(params[:do])
      {name, _, [params]}     -> make_warmer(name, params[:do])
      {name, _, params}       -> make_warmer(name, params)
    end
  end

  def make_warmer(name, options, warmers_opts \\ [])

  def make_warmer(name, options, _warmers_opts) when is_list(options) do
    Keyword.put([], to_atom(name), routers(name, extract_do(options, 1), []) ++ Enum.fetch!(options, 0))
  end

  def make_warmer(name, options, warmers_opts) do
    Keyword.put([], to_atom(name), routers(name, options, []) ++ warmers_opts)
  end

  def source(options, source_opts \\ [])

  def source(options, _source_opts) when is_list(options) do
    [source:  extract(extract_do(options, 1)) ++ Enum.fetch!(options, 0)]
  end

  def source(options, source_opts) do
    [source:  extract(options) ++ source_opts]
  end

  defp routers(name, options, add_options) do
    case options do
      {:source, _, [params]} -> source(params[:do])
      options                -> Keyword.put([], to_atom(name), extract(options) ++ add_options)
    end
  end
end
