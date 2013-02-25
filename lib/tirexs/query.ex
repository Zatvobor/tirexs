defmodule Tirexs.Query do

  #Missing query type: [boosting custom_boost_factor]

  import Tirexs.Query.Helpers
  import Tirexs.Helpers

  defmacro __using__(_) do
    quote do
      import unquote(Tirexs.Query)
      use unquote(Tirexs.Query.Bool)
      use unquote(Tirexs.Query.DisMax)
      use unquote(Tirexs.Query.Filtered)
    end
  end

  defmacro query([do: block]) do
    [query: extract_array(scoped_query(block))]
  end

  def match(options) do
    [field, value, options] = extract_options(options)
    [match: Dict.put([], to_atom(field), [query: value] ++ options)]
  end

  def range(options) do
    [field, value, _] = extract_options(options)
    [range: Dict.put([], to_atom(field), value)]
  end

  def multi_match(options) do
    [query, fields, options] = extract_options(options)
    [multi_match: [query: query, fields: fields]]
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