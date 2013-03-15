defmodule Tirexs.Warmer do
  @moduledoc false

  use Tirexs.DSL.Logic


  def transpose(block) do
    case block do
      {:filter, _, [params]}          -> Tirexs.Filter._filter(params[:do])
      {:query, _, [params]}           -> Tirexs.Query._query(params[:do])
      {:facets, _, [params]}          -> Tirexs.Facets._facets(params[:do])
      {name, _, [params]}             -> Tirexs.Warmer.make_warmer(name, params[:do])
      {name, _, params}               -> Tirexs.Warmer.make_warmer(name, params)
    end
  end

  defmacro warmers([do: block]) do
    [warmers: extract(block)]
  end

  def make_warmer(name, options, warmers_opts//[]) do
    if is_list(options) do
      warmers_opts = Enum.at!(options, 0)
      options = extract_do(options, 1)
    end
    Dict.put([], to_atom(name), routers(name, options, []) ++ warmers_opts)
  end

  def source(options, source_opts//[]) do
    if is_list(options) do
      source_opts = Enum.at!(options, 0)
      options = extract_do(options, 1)
    end
    [source:  extract(options) ++ source_opts]
  end

  defp routers(name, options, add_options) do
    case options do
      {:source, _, [params]} -> source(params[:do])
      options                -> Dict.put([], to_atom(name), extract(options) ++ add_options)
    end
  end
end