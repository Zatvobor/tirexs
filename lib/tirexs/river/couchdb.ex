defmodule Tirexs.River.Couchdb do

  defmacro couchdb([do: block]) do
    quote do
      var!(river) = var!(river) ++ [couchdb: unquote(block)]
    end
  end

end