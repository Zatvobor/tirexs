defmodule Tirexs.Query do

  #Missing query type: [boosting custom_boost_factor]

  defmacro __using__(_) do
    quote do
      import unquote(Tirexs.Query)
      use unquote(Tirexs.Query.Bool)
      use unquote(Tirexs.Query.DisMax)
      use unquote(Tirexs.Query.Filtered)
    end
  end

  defmacro query([do: block]) do
    quote do
      unquote(block)
    end
  end

  defmacro match(field, value, options) do
    quote do
      [field, value, options] = [unquote(field), unquote(value), unquote(options)]
      IO.puts field
    end
  end

  defmacro multi_match(fields, value, options) do
    quote do
      [fields, value, options] = [unquote(fields), unquote(value), unquote(options)]
      IO.puts fields
    end
  end

  defmacro text(field, value, options) do
    quote do
      [field, value, options] = [unquote(field), unquote(value), unquote(options)]
      IO.puts field
    end
  end

  defmacro ids(type, values) do
    quote do
      [type, values] = [unquote(type), unquote(values)]
    end
  end

  defmacro custom_score(options, [do: block]) do
    quote do
      options = unquote(options)
      unquote(block)
    end
  end

  defmacro constant_score(options, [do: block]) do
    quote do
      options = unquote(options)
      unquote(block)
    end
  end

  defmacro dis_max(options, [do: block]) do
    quote do
      options = unquote(options)
      unquote(block)
    end
  end

  defmacro field(field, value) do
    #note value can be a dict or string =)
    quote do
      [field, value] = [unquote(field), unquote(value)]
    end
  end



end