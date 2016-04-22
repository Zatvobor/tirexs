defmodule Tirexs.Search do
  @moduledoc """
  Provides DSL-like macros for search query definition.

  Search query definition:

      query = search [index: "bear_test"] do
        query do
          nested [path: "comments"] do
            query do
              bool do
                must do
                  match "comments.author",  "John"
                  match "comments.message", "cool"
                end
              end
            end
          end
        end
      end

      Tirexs.Query.create_resource(query)


  """


  use Tirexs.DSL.Logic

  @doc false
  defmacro search([do: block]) do
    [search: extract(block)]
  end

  @doc false
  defmacro search(options, [do: block]) do
    [options, index_opts] = extract_index_options(options)
    [search: extract(block) ++ options] ++ index_opts
  end


  alias Tirexs.{Query, Query.Filter}
  alias Tirexs.{Search.Aggs, Search.Suggest, Search.Rescore}


  @doc false
  def transpose(block) do
    case block do
      {:query, _, [params]}         -> Query._query(params[:do])
      {:query, _, options}          -> Query._query(options)
      {:filter, _, [params]}        -> Filter._filter(params[:do])
      {:filter, _, options}         -> Filter._filter(options)
      {:aggs, _, [params]}          -> Aggs._aggs(params[:do])
      {:highlight, _, [params]}     -> highlight(params)
      {:sort, _, [params]}          -> sort(params)
      {:size, _, [param]}           -> size(param)
      {:from, _, [param]}           -> from(param)
      {:script_fields, _, [params]} -> script_fields(params)
      {:suggest, _, [params]}       -> Suggest._suggest(params[:do])
      {:suggest, _, options}        -> Suggest._suggest(options)
      {:rescore, _, [params]}       -> Rescore._rescore(params[:do])
      {:rescore, _, options}        -> Rescore._rescore(options)
      {:filters, _, [options]}      -> filters(options, [])
    end
  end

  @doc false
  def filters(params, _opts) do
    [filter: params]
  end

  @doc false
  def highlight([do: block]) do
    [highlight: block]
  end

  @doc false
  def sort([do: block]) do
    [sort: block]
  end

  @doc false
  def size(param) do
    [size: param]
  end

  @doc false
  def from(param) do
    [from: param]
  end

  @doc false
  def script_fields([do: block]) do
    [script_fields: block]
  end

  @doc false
  def extract_index_options(options, index_opts \\ []) do
    if options[:index] do
      index_opts = index_opts ++ [index: options[:index]]
      options = Keyword.delete(options, :index)
    end

    if options[:type] do
      index_opts = index_opts ++ [type: options[:type]]
      options = Keyword.delete(options, :type)
    end
    [options, index_opts]
  end
end
