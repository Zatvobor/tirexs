defmodule Tirexs.Search.Aggregations do
  @moduledoc false

  use Tirexs.DSL.Logic


  @doc false
  defmacro aggs([do: block]) do
    [aggs: extract(block)]
  end


  alias Tirexs.{Query.Filter}

  def transpose(block) do
    case block do
      {:filter, _, [params]}  -> Filter._filter(params[:do])
      {name, _, [params]}     -> make_aggs(name, params[:do])
      {name, _, params}       -> make_aggs(name, params)
    end
  end

  def make_aggs(name, options, aggs_opts \\ []) do
    routers(name, options, aggs_opts)
  end


  defp routers(name, options, aggs_opts) do
    case options do
      options -> Dict.put([], to_atom(name), extract(options) ++ aggs_opts)
    end
  end
end
