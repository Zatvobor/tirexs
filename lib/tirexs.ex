defmodule Tirexs do
  @moduledoc ~S"""
  Tirexs is split into several components:

    * `Tirexs.HTTP` - the elasticsearch REST APIs are exposed using JSON over HTTP.
      The bare-bone for sending and getting back HTTP responses.

  Please check https://github.com/Zatvobor/tirexs/tree/master/examples for getting
  more details what exactly Tirexs does for you.

  """


  @doc false
  def get_all_env() do
    Application.get_all_env(:tirexs)
  end

  @doc false
  def get_env(key) do
    Application.get_env(:tirexs, key)
  end

  @doc false
  def get_uri_env() do
    get_env(:uri)
  end

  @doc """
  Utilities for managing code compilation, code evaluation and code loading, useful if
  you want to load DSL flavored things from standalone files.

  ## Examples

      Path.expand("examples/mapping.exs") |> Tirexs.load_file

  These functions just delegate to `Code` module.

  """
  defdelegate [load_file(file), load_file(file, relative_to)], to: Code
end
