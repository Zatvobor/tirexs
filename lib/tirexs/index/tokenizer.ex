defmodule Tirexs.Index.Tokenizer do
  defmacro tokenizer(name, value) do
    quote do
      if var!(index)[:settings][:analysis][:tokenizer] == nil do
        var!(index) = put_index_setting(var!(index), :analysis, :tokenizer)
      end
      [name, value] = [unquote(name), unquote(value)]
      var!(index) = add_index_setting(var!(index), :analysis, :tokenizer, Dict.put([], to_atom(name), value))
    end
  end
end