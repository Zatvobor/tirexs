defmodule Tirexs.MultiGet do
  @moduledoc """
  Multi GET API allows to get multiple documents based on an index,
  type (optional) and id (and possibly routing).

  """


  @doc false
  defmacro mget([do: block]) do
    quote do
      Tirexs.HTTP.encode(unquote(block)) <> "\n"
    end
  end


  @doc false
  def ids(list) do
    [ ids: Enum.map(list, fn(id) -> id end) ]
  end

  @doc false
  def docs(list) do
    [ docs: Enum.map(list, fn(item) -> undescored_keys(item) end) ]
  end


  @undescored [ :id, :index, :type, :source, :routing ]

  @doc false
  defp undescored_keys(list) do
    Enum.map(list, fn({k,v}) ->
      if Enum.member?(@undescored, k), do: {:"_#{k}", v}, else: {k,v}
    end)
  end
end
