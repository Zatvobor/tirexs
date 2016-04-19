defmodule Tirexs do
  @moduledoc ~S"""
  Tirexs is split into several layers.

  ## Raw HTTP layer:

    * `Tirexs.ENV` - the environment-specific `%URI{}` struct. The struct has been
      used for building the HTTP location.

    * `Tirexs.HTTP` - the elasticsearch REST APIs are exposed using JSON over HTTP.
      The bare-bone for sending HTTP requests and getting them back.

    * `Tirexs.Resources` -  helps you to build an URN parts and
      compose them with `%URI{}`.

    * `Tirexs.Resources.APIs` - helps you to build an URN parts from set of
      available REST API helpers into request URL.

  Please check https://github.com/Zatvobor/tirexs/tree/master/examples for getting
  more details what exactly Tirexs does for you.

  """


  defdelegate [get_all_env(), get_env(key), get_uri_env], to: Tirexs.ENV

  @doc """
  Utilities for managing code compilation, code evaluation and code loading, useful if
  you want to load DSL flavored things from standalone files.

  ## Examples

      Path.expand("examples/mapping.exs") |> Tirexs.load_file

  These functions just delegate to `Code` module.

  """
  defdelegate [load_file(file), load_file(file, relative_to)], to: Code

  @doc false
  defdelegate [bump(), bump(uri), bump(body,uri), bump!(), bump!(uri), bump!(body,uri)], to: Tirexs.Resources
end
