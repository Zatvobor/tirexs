defmodule Tirexs do
  @moduledoc false


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
    uri = get_env(:uri)
    if Keyword.keyword?(uri) do
      Enum.reduce uri, %URI{}, fn ({key, value}, uri_struct) ->
        %{ uri_struct | key => value }
      end
    else
      uri
    end
  end
end
