defmodule Tirexs.Index.Analyzer do
  defmacro analyzer(name, value) do
    quote do
      if var!(index)[:settings][:analysis][:analyzer] == nil do
        var!(index) = put_index_setting(var!(index), :analysis, :analyzer)
      end
      [name, value] = [unquote(name), unquote(value)]
      var!(index) = add_index_setting(var!(index), :analysis, :analyzer, Dict.put([], to_atom(name), value))
    end
  end
end