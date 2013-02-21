defmodule Tirexs.Index.Blocks do

  defmacro write(value) do
    quote do
      value = unquote(value)
    end
  end

  defmacro metadata(value) do
    quote do
      value = unquote(value)
    end
  end

  defmacro read(value) do
    quote do
      value = unquote(value)
    end
  end

  defmacro read_only(value) do
    quote do
      value = unquote(value)
    end
  end

end