defmodule Tirexs.Search do
  @moduledoc false

  use Tirexs.DSL.Logic

  alias Tirexs.Query, as: Query
  alias Tirexs.Query.Filter, as: Filter
  alias Tirexs.Search.Facets, as: Facets
  alias Tirexs.Search.Suggest, as: Suggest
  alias Tirexs.Search.Rescore, as: Rescore


  def transpose(block) do
    case block do
      {:query, _, [params]}         -> Query._query(params[:do])
      {:query, _, options}          -> Query._query(options)
      {:filter, _, [params]}        -> Filter._filter(params[:do])
      {:filter, _, options}         -> Filter._filter(options)
      {:facets, _, [params]}        -> Facets._facets(params[:do])
      {:highlight, _, [params]}     -> highlight(params)
      {:sort, _, [params]}          -> sort(params)
      {:script_fields, _, [params]} -> script_fields(params)
      {:suggest, _, [params]}       -> Suggest._suggest(params[:do])
      {:suggest, _, options}        -> Suggest._suggest(options)
      {:rescore, _, [params]}       -> Rescore._rescore(params[:do])
      {:rescore, _, options}        -> Rescore._rescore(options)
      {:filters, _, [options]}      -> filters(options, [])
    end
  end


  defmacro search([do: block]) do
    [search: extract(block)]
  end

  defmacro search(options, [do: block]) do
    [options, index_opts] = extract_index_options(options)
    [search: extract(block) ++ options] ++ index_opts
  end

  def filters(params, _opts) do
    [filter: params]
  end

  def highlight([do: block]) do
    [highlight: block]
  end

  def sort([do: block]) do
    [sort: block]
  end

  def script_fields([do: block]) do
    [script_fields: block]
  end

  def extract_index_options(options, index_opts \\ []) do
    if options[:index] do
      index_opts = index_opts ++ [index: options[:index]]
      options = Dict.delete(options, :index)
    end

    if options[:type] do
      index_opts = index_opts ++ [type: options[:type]]
      options = Dict.delete(options, :type)
    end
    [options, index_opts]
  end
end