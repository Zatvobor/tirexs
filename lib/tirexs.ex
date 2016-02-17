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
    get_env(:uri)
  end
end
