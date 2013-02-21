defmodule Tirex.Index.Cache do
  defmacro max_size(value) do
    quote do
      value = unquote(value)
    end
  end

  defmacro expire(value) do
    quote do
      value = unquote(value)
    end
  end
end