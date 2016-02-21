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
end
