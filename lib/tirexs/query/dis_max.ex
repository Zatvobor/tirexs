defmodule Tirexs.Query.DisMax do
  defmacro __using__(_) do
    quote do
      import unquote(Tirexs.Query.DisMax)
    end
  end
end