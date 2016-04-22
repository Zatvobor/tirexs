defmodule Tirexs.MultiGet do
  @moduledoc """
  Multi GET API allows to get multiple documents based on an index,
  type (optional) and id (and possibly routing).

  A `mget` macro helps create a request `body`.

  Getting multiple documents by their id:

      request = mget do
        ids([ 1, 2 ])
      end
      Tirexs.bump(request)._mget("bear_test", "my_type")

  Getting multiple documents:

      request = mget do
        docs([
          [ index: "bear_test", type: "bear_type", id: 1, fields: [] ],
          [ index: "bear_test", type: "bear_type", id: 2, source: false ]
        ])
      end
      Tirexs.bump(request)._mget()

  """


  @doc "A `mget` macro helps create a request `body`."
  defmacro mget([do: block]) do
    quote do
      Tirexs.HTTP.encode(unquote(block)) <> "\n"
    end
  end


  @doc "gets multiple documents by their id."
  def ids(list) do
    [ ids: Enum.map(list, fn(id) -> id end) ]
  end

  @doc "gets multiple documents."
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
