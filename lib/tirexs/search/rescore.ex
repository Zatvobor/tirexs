defmodule Tirexs.Search.Rescore do
  @moduledoc false

  use Tirexs.DSL.Logic


  @doc false
  defmacro rescore([do: block]) do
    [rescore: extract(block)]
  end

  @doc false
  defmacro rescore(options, [do: block]) do
    [rescore: extract(block) ++ options]
  end


  alias Tirexs.{Query, Query.Filter}

  @doc false
  def transpose(block) do
    case block do
      {:query, _, [params]}  -> Query._query(params[:do])
      {:query, _, options}   -> Query._query(options)
      {:filter, _, [params]} -> Filter._filter(params[:do])
      {:filter, _, options}  -> Filter._filter(options)
    end
  end

  @doc false
  def _rescore(options, rescore_opts \\ [])

  @doc false
  def _rescore(options, _rescore_opts) when is_list(options) do
    [rescore: extract(extract_do(options, 1)) ++ Enum.fetch!(options, 0)]
  end

  @doc false
  def _rescore(options, rescore_opts) do
    [rescore: extract(options) ++ rescore_opts]
  end
end
