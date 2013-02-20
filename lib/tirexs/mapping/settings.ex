defmodule Tirexs.Mapping.Settings do

  defmacro settings([do: block]) do
    quote do
      var!(index) = HashDict.put(var!(index), :settings, [])
      unquote(block)
    end
  end

  defmacro settings(settings, [do: block]) do
    quote do
      var!(index) = HashDict.put(var!(index), :settings, unquote(settings))
      unquote(block)
    end
  end
end