defmodule Tirexs.Index.Cache do

  defmacro cache(value) do
    quote do
      if var!(index)[:settings][:index][:cache] == nil do
        var!(index) = put_index_setting(var!(index), :index, :cache)
        var!(index) = add_index_setting(var!(index), :index, :cache, [filter: []])
      end
      value = unquote(value)
      var!(index) = add_index_setting_nested_type(var!(index), :index, :cache, :filter, value)
    end
  end

end