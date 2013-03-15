defmodule Tirexs.Search.Suggest do
  @moduledoc false

  use Tirexs.DSL.Logic


  def transpose(block) do
    case block do
      {:filter, _, [params]} -> Tirexs.Filter._filter(params[:do])
      {:query, _, [params]}  -> Tirexs.Query._query(params[:do])
      {:fuzzy, _, params}    -> Tirexs.Query.fuzzy(params)
      {name, _, [params]}    -> Tirexs.Search.Suggest.make_suggest(name, params[:do])
      {name, _, params}      -> Tirexs.Search.Suggest.make_suggest(name, params)
    end
  end

  defmacro suggest([do: block]) do
    [suggest: extract(block)]
  end

  defmacro suggest(options, [do: block]) do
    [suggest: extract(block) ++ options]
  end

  def _suggest(options, suggest_opts//[]) do
    if is_list(options) do
      suggest_opts = Enum.at!(options, 0)
      options = extract_do(options, 1)
    end
    [suggest: extract(options) ++ suggest_opts]
  end

  def make_suggest(name, options, suggest_opts//[]) do
    if is_list(options) do
      suggest_opts = Enum.at!(options, 0)
      options = extract_do(options, 1)
    end
      routers(name, options, suggest_opts)
  end

  defp routers(name, options, add_options) do
    case options do
      options -> Dict.put([], to_atom(name), extract(options) ++ add_options)
    end
  end
end