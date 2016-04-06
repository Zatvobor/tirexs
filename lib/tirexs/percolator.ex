defmodule Tirexs.Percolator do
  @moduledoc false

  use Tirexs.DSL.Logic
  alias Tirexs.{HTTP}


  @doc false
  defmacro percolator([do: block]) do
    extract(block)
  end

  @doc false
  defmacro percolator(options, [do: block]) do
    [options, index_opts] = Tirexs.Search.extract_index_options(options)
    extract(block) ++ options ++ index_opts
  end


  alias Tirexs.Query

  @doc false
  def transpose(block) do
    case block do
      {:query, _, [params]} -> Query._query(params[:do])
      {:query, _, options}  -> Query._query(options)
      {:doc, _, [params]}   -> doc(params[:do])
      {:doc, _, options}    -> doc(options)
    end
  end

  @doc false
  def doc(options, doc_opts \\ []) do
    options = List.first(extract_block(options))
    [doc: extract_block(options) ++ doc_opts]
  end

  @doc false
  def create_resource(definition, uri \\ Tirexs.get_uri_env()) do
    Tirexs.bump(definition, uri).percolator(definition[:index], definition[:name])
  end

  @doc false
  def to_resource_json(definition) do
    definition = Keyword.delete(definition, :index)
    definition = Keyword.delete(definition, :type)
    definition = Keyword.delete(definition, :name)

    HTTP.encode(definition)
  end

  @doc false
  def match(definition, uri \\ Tirexs.get_uri_env()) do
    Tirexs.bump(definition, uri)._percolate(definition[:index], definition[:type])
  end
end
