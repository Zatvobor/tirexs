defmodule Tirexs.Query.Bool do
  defmacro __using__(_) do
    quote do
      import unquote(Tirexs.Query.Bool)
    end
  end

  defmacro bool([do: block]) do
    quote do
      var!(query) = Dict.put(var!(query), :query, [bool: []])
      unquote(block)
    end
  end

  defmacro must([do: block]) do
    quote do
      unquote(block)
    end
  end

  defmacro should([do: block]) do
    quote do
      unquote(block)
    end
  end

  defmacro must_not([do: block]) do
    quote do
      unquote(block)
    end
  end

end