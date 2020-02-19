defmodule Tirexs.DSL do
  @moduledoc """
  This module represents a main entry point for creating resources from DSL.

  The resource types are allowed to be `settings`, `mapping`, `search`, definitions.

  This convenience allows you to define particular resources over `*.exs`
  snippets and load them by request, for instance:

      iex> Path.expand("examples/settings.exs") |> Tirexs.load_file

  Find out more samples right in `/examples` directory.

  """


  @doc """
  Calls a `definition_fn/1,2` function and will create their resource. The resource
  types are allowed to be `settings`, `mapping`, `search`.

  """
  def define(initial, definition_fn) do
    case :erlang.fun_info(definition_fn, :arity) do
      {:arity, 1} ->
        definition = definition_fn.(initial)
        create_resource(definition)
      {:arity, 2} ->
        {definition, uri} = definition_fn.(initial, Tirexs.get_uri_env())
        create_resource(definition, uri)
    end
  end

  @doc """
  Calls a `definition_fn/0,1` function and will create their resource. The resource
  types are allowed to be `settings`, `mapping`, `search`.

  """
  def define(definition_fn) when is_function(definition_fn) do
    case :erlang.fun_info(definition_fn, :arity) do
      {:arity, 0} ->
        definition = definition_fn.()
        create_resource(definition)
      {:arity, 1} ->
        { definition, uri } = definition_fn.(Tirexs.get_uri_env())
        create_resource(definition, uri)
    end
  end


  alias Tirexs.{ElasticSearch.Settings, Mapping, Query}

  defp create_resource(definition, uri \\ Tirexs.get_uri_env()) do
    cond do
      definition[:settings]   -> Settings.create_resource(definition, uri)
      definition[:mapping]    -> Mapping.create_resource(definition, uri)
      definition[:search]     -> Query.create_resource(definition, uri)
    end
  end
end
