defmodule Tirexs.Index.Filter do
  defmacro filter(name, value) do
    quote do
      if var!(index)[:settings][:analysis][:filter] == nil do
        var!(index) = put_index_setting(var!(index), :analysis, :filter)
      end
      [name, value] = [unquote(name), unquote(value)]
      var!(index) = add_index_setting(var!(index), :analysis, :filter, Dict.put([], to_atom(name), value))
    end
  end
end