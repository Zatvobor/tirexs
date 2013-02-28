defmodule Tirexs.River do
  defmacro __using__(_) do
    quote do
      import unquote(Tirexs.River)
      import unquote(Tirexs.River.Couchdb)
    end
  end

  defmacro river([do: block]) do
    quote do
      var!(river) = var!(river) ++ [river: true]
      unquote(block)
    end
  end

  defmacro type(value) do
    quote do
      var!(river) = var!(river) ++ [type: unquote(value)]
    end
  end

  defmacro index([do: block]) do
    quote do
      var!(river) = var!(river) ++ [index: unquote(block)]
    end
  end

  def init_river(settings) do
    settings
  end
end