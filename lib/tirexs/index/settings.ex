defmodule Tirexs.Index.Settings do
  defmacro __using__(_) do
    quote do
      import unquote(Tirexs.Index.Settings)
      import unquote(Tirexs.Index.Helpers)
      import unquote(Tirexs.Index.Blocks)
      import unquote(Tirexs.Index.Translog)
      import unquote(Tirexs.Index.Merge)
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

  defmacro filter(name, properties) do
    quote do
      [name, properties] = [unquote(name), unquote(properties)]
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

  defmacro analyzer(name, properties) do
    quote do
      [name, properties] = [unquote(name), unquote(properties)]
    end
  end

  defmacro index(settings) do
  end

  defmacro blocks([do: block]) do
    quote do
      if var!(index)[:settings][:index][:blocks] == nil do
        var!(index) = put_index_setting(var!(index), :blocks)
      end
      unquote(block)
    end
  end

  defmacro cache([do: block]) do
    quote do
      if var!(index)[:settings][:index][:cache] == nil do
        var!(index) = put_index_setting(var!(index), :cache)
      end
      unquote(block)
    end
  end

end