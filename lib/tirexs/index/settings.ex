defmodule Tirexs.Index.Settings do
  @moduledoc false

  import Tirexs.DSL.Logic
  import Tirexs.Index.Logic


  @doc false
  defmacro settings([do: block]) do
    quote do
      var!(index) = Dict.put(var!(index), :settings, [])
      var!(index) = put_setting(var!(index), :index)
      unquote(block)
    end
  end

  @doc false
  defmacro filters([do: block]) do
    quote do
      if var!(index)[:settings][:analysis] == nil do
        var!(index) = put_setting(var!(index), :analysis)
      end
      unquote(block)
    end
  end

  @doc false
  defmacro analysis([do: block]) do
    quote do
      if var!(index)[:settings][:analysis] == nil do
        var!(index) = put_setting(var!(index), :analysis)
      end
      unquote(block)
    end
  end

  @doc false
  defmacro set(settings) do
    quote do
      settings = unquote(settings)
      var!(index) = add_index_setting(var!(index), settings)
    end
  end

  @doc false
  defmacro analyzer(name, value) do
    quote do
      if var!(index)[:settings][:analysis][:analyzer] == nil do
        var!(index) = put_index_setting(var!(index), :analysis, :analyzer)
      end
      [name, value] = [unquote(name), unquote(value)]
      var!(index) = add_index_setting(var!(index), :analysis, :analyzer, Dict.put([], to_atom(name), value))
    end
  end

  @doc false
  defmacro blocks(value) do
    quote do
      if var!(index)[:settings][:index][:blocks] == nil do
        var!(index) = put_index_setting(var!(index), :index, :blocks)
      end
      value = unquote(value)
      var!(index) = add_index_setting(var!(index), :index, :blocks, value)
    end
  end

  @doc false
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

  @doc false
  defmacro filter(name, value) do
    quote do
      if var!(index)[:settings][:analysis][:filter] == nil do
        var!(index) = put_index_setting(var!(index), :analysis, :filter)
      end
      [name, value] = [unquote(name), unquote(value)]
      var!(index) = add_index_setting(var!(index), :analysis, :filter, Dict.put([], to_atom(name), value))
    end
  end

  @doc false
  defmacro char_filter(name, value) do
    quote do
      if var!(index)[:settings][:analysis][:char_filter] == nil do
        var!(index) = put_index_setting(var!(index), :analysis, :char_filter)
      end
      [name, value] = [unquote(name), unquote(value)]
      var!(index) = add_index_setting(var!(index), :analysis, :char_filter, Dict.put([], to_atom(name), value))
    end
  end

  @doc false
  defmacro tokenizer(name, value) do
    quote do
      if var!(index)[:settings][:analysis][:tokenizer] == nil do
        var!(index) = put_index_setting(var!(index), :analysis, :tokenizer)
      end
      [name, value] = [unquote(name), unquote(value)]
      var!(index) = add_index_setting(var!(index), :analysis, :tokenizer, Dict.put([], to_atom(name), value))
    end
  end

  @doc false
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
