defmodule Tirexs.Index.Blocks do
  defmacro blocks(value) do
    quote do
      if var!(index)[:settings][:index][:blocks] == nil do
        var!(index) = put_index_setting(var!(index), :index, :blocks)
      end
      value = unquote(value)
      var!(index) = add_index_setting(var!(index), :index, :blocks, value)
    end
  end
end