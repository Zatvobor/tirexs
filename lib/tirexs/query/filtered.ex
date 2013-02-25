defmodule Tirexs.Query.Filtered do
  defmacro __using__(_) do
    quote do
      import unquote(Tirexs.Query.Filtered)
    end
  end
end