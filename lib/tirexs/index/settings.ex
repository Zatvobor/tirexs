defmodule Tirexs.Index.Settings do
  defmacro __using__(_) do
    quote do
      import unquote(Tirexs.Index.Settings)
      import unquote(Tirexs.Index.Helpers)
      import unquote(Tirexs.Index.Blocks)
      import unquote(Tirexs.Index.Translog)
      import unquote(Tirexs.Index.Cache)
      import unquote(Tirexs.Index.Merge)
      import unquote(Tirexs.Index.Analyzer)
      import unquote(Tirexs.Index.Tokenizer)
      import unquote(Tirexs.Index.Filter)
      import unquote(Tirexs.Helpers)
    end
  end

  defmacro settings([do: block]) do
    quote do
      var!(index) = HashDict.put(var!(index), :settings, [])
      var!(index) = put_setting(var!(index), :index)
      unquote(block)
    end
  end

  defmacro filters([do: block]) do
    quote do
      if var!(index)[:settings][:analysis] == nil do
        var!(index) = put_setting(var!(index), :analysis)
      end
      unquote(block)
    end
  end

  defmacro analysis([do: block]) do
    quote do
      if var!(index)[:settings][:analysis] == nil do
        var!(index) = put_setting(var!(index), :analysis)
      end
      unquote(block)
    end
  end

  defmacro set(settings) do
    quote do
      settings = unquote(settings)
      var!(index) = add_index_setting(var!(index), settings)
    end
  end

end