defmodule Tirexs.DSL do
  @moduledoc false
  @note """
  This module represents a main entry point for defining DSL scenarios.

  Check an `examples` directory which consists a DSL templates for `mapping`,
  `settings` and `query` definitions.

  """


  @doc false
  def define(definition, definition_fn) do
    uri = Tirexs.get_uri_env()
    case definition_fn.(definition, uri) do
      { definition, uri } -> create_resource(definition, uri)
    end
  end

  @doc false
  def define(definition_fn) do
    uri = Tirexs.get_uri_env()
    case definition_fn.(uri) do
      { definition, uri } -> create_resource(definition, uri)
    end
  end


  defp create_resource(definition, uri) do
    cond do
      definition[:settings]   -> Tirexs.ElasticSearch.Settings.create_resource(definition, uri)
      definition[:mapping]    -> Tirexs.Mapping.create_resource(definition, uri)
      definition[:search]     -> Tirexs.Query.create_resource(definition, uri)
      definition[:percolator] -> Tirexs.Percolator.create_resource(definition[:percolator], uri)
    end
  end
end
