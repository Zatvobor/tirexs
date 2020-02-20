defmodule Tirexs.Index.Settings do
  @moduledoc false

  import Tirexs.DSL.Logic
  import Tirexs.Index.Logic


  @doc false
  defmacro settings([do: block]) do
    quote do
      var!(index) = Keyword.put(var!(index), :settings, [])
      unquote(block)
    end
  end

  @doc false
  defmacro filters([do: block]) do
    quote do
      var!(index) = put_setting(var!(index), :analysis)
      unquote(block)
    end
  end

  @doc false
  defmacro analysis([do: block]) do
    quote do
      var!(index) = put_setting(var!(index), :analysis)
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
      var!(index) = put_index_setting(var!(index), :analysis, :analyzer)
      [name, value] = [unquote(name), unquote(value)]
      var!(index) = add_index_setting(var!(index), :analysis, :analyzer, Keyword.put([], to_atom(name), value))
    end
  end

  @doc false
  defmacro normalizer([do: block]) do
    quote do
      var!(index) = put_index_setting(var!(index), :analysis, :normalizer)
      [name, value] = [unquote(name), unquote(value)]
      var!(index) = add_index_setting(var!(index), :analysis, :normalizer, Keyword.put([], to_atom(name), value))
    end
  end
 
  @doc false
  defmacro blocks(value) do
    quote do
      var!(index) = put_index_setting(var!(index), :blocks)
      value = unquote(value)
      var!(index) = add_index_setting(var!(index), :blocks, value)
    end
  end

  @doc false
  defmacro cache(value) do
    quote do
      var!(index) = put_index_setting(var!(index), :cache)
      var!(index) = put_index_setting_nested_type(var!(index), :cache, :filter)
      value = unquote(value)
      var!(index) = add_index_setting_nested_type(var!(index), :cache, :filter, value)
    end
  end

  @doc false
  defmacro filter(name, value) do
    quote do
      var!(index) = put_index_setting(var!(index), :analysis, :filter)
      [name, value] = [unquote(name), unquote(value)]
      var!(index) = add_index_setting(var!(index), :analysis, :filter, Keyword.put([], to_atom(name), value))
    end
  end

  @doc false
  defmacro char_filter(name, value) do
    quote do
      var!(index) = put_index_setting(var!(index), :analysis, :char_filter)
      [name, value] = [unquote(name), unquote(value)]
      var!(index) = add_index_setting(var!(index), :analysis, :char_filter, Keyword.put([], to_atom(name), value))
    end
  end

  @doc false
  defmacro tokenizer(name, value) do
    quote do
      var!(index) = put_index_setting(var!(index), :analysis, :tokenizer)
      [name, value] = [unquote(name), unquote(value)]
      var!(index) = add_index_setting(var!(index), :analysis, :tokenizer, Keyword.put([], to_atom(name), value))
    end
  end

  @doc false
  defmacro translog(value) do
    quote do
      var!(index) = put_index_setting(var!(index), :translog)
      value = unquote(value)
      var!(index) = add_index_setting(var!(index), :translog, value)
    end
  end
end
