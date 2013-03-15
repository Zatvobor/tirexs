defmodule Tirexs.Search.Rescore do
  @moduledoc false

  use Tirexs.DSL.Logic

  alias Tirexs.Query, as: Query
  alias Tirexs.Query.Filter, as: Filter

  def transpose(block) do
    case block do
      {:query, _, [params]}  -> Query._query(params[:do])
      {:query, _, options}   -> Query._query(options)
      {:filter, _, [params]} -> Filter._filter(params[:do])
      {:filter, _, options}  -> Filter._filter(options)
    end
  end

  defmacro rescore([do: block]) do
    [rescore: extract(block)]
  end

  defmacro rescore(options, [do: block]) do
    [rescore: extract(block) ++ options]
  end

  def _rescore(options, rescore_opts//[]) do
    if is_list(options) do
      rescore_opts = Enum.at!(options, 0)
      options = extract_do(options, 1)
    end
    [rescore: extract(options) ++ rescore_opts]
  end
end