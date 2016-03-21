defmodule Tirexs do
  @moduledoc ~S"""
  Tirexs is split into several components:

    * `Tirexs.HTTP` - the elasticsearch REST APIs are exposed using JSON over HTTP.
      The bare-bone for sending and getting back HTTP responses.

  Please check https://github.com/Zatvobor/tirexs/tree/master/examples for getting
  more details what exactly Tirexs does for you.

  """


  @doc """
  The state of `Tirexs.ENV` is to made up a main `%URI{}` struct from
  `System.get_env("ES_URI")` or `Application.get_env(:tirexs, :uri)` sources.

  By default a `Tirexs.get_uri_env/0` returns `%URI{ authority: "127.0.0.1:9200", scheme: "http", host: "127.0.0.1", port: 9200 }` struct.

  To setup your own uri to elasticsearch node you're able to useone of these available options:

  Environment variable:

      ES_URI=http://127.0.0.1:9200

  Over `Mix.Config.config/2`:

      config :tirexs, :uri, %URI{ authority: "127.0.0.1:9200", scheme: "http", host: "127.0.0.1", port: 9200 }
      config :tirexs, :uri, [ authority: "127.0.0.1:9200", scheme: "http", host: "127.0.0.1", port: 9200 ]
      config :tirexs, :uri, "http://127.0.0.1:9200"

  Over `Application.put_env/3`:

      put_env :tirexs, :uri, %URI{ authority: "127.0.0.1:9200", scheme: "http", host: "127.0.0.1", port: 9200 }
      put_env :tirexs, :uri, [ authority: "127.0.0.1:9200", scheme: "http", host: "127.0.0.1", port: 9200 ]
      put_env :tirexs, :uri, "http://127.0.0.1:9200"

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
