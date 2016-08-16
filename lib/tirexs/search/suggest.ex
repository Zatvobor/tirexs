defmodule Tirexs.Search.Suggest do
  @moduledoc false

  use Tirexs.DSL.Logic


  @doc false
  defmacro suggest([do: block]) do
    [suggest: extract(block)]
  end

  @doc false
  defmacro suggest(options, [do: block]) do
    [suggest: extract(block) ++ options]
  end


  alias Tirexs.{Query, Query.Filter}

  @doc false
  def transpose(block) do
    case block do
      {:filter, _, [params]} -> Filter._filter(params[:do])
      {:query, _, [params]}  -> Query._query(params[:do])
      {:fuzzy, _, params}    -> Query.fuzzy(params)
      {name, _, [params]}    -> make_suggest(name, params[:do])
      {name, _, params}      -> make_suggest(name, params)
    end
  end

  @doc false
  def _suggest(options, suggest_opts \\ [])

  @doc false
  def _suggest(options, _suggest_opts) when is_list(options) do
    suggest_opts = extract_do(options, 1)
    options = Enum.fetch!(options, 0)
    [suggest: extract(suggest_opts) ++ options]
  end

  @doc false
  def _suggest(options, suggest_opts) do
    [suggest: extract(options) ++ suggest_opts]
  end

  @doc false
  def make_suggest(name, options, suggest_opts \\ [])

  @doc false
  def make_suggest(name, options, _suggest_opts) when is_list(options) do
    suggest_opts = extract_do(options, 1)
    options = Enum.fetch!(options, 0)
    routers(name, suggest_opts, options)
  end

  @doc false
  def make_suggest(name, options, suggest_opts) do
    routers(name, options, suggest_opts)
  end

  defp routers(name, options, add_options) do
    case options do
      options -> Keyword.put([], to_atom(name), extract(options) ++ add_options)
    end
  end
end
