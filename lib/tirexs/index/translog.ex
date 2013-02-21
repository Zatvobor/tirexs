defmodule Tirexs.Index.Translog do
  defmacro translog(value) do
    quote do
      if var!(index)[:settings][:index][:translog] == nil do
        var!(index) = put_index_setting(var!(index), :index, :translog)
      end
      value = unquote(value)
      var!(index) = add_index_setting(var!(index), :index, :translog, value)
    end
  end
end