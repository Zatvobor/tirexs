defmodule Tirexs.Mapping do
  import Tirexs.Mapping.Helpers
  import Tirexs.Helpers

  defmacro __using__(_) do
    quote do
      import unquote(Tirexs.Mapping)
    end
  end

  defmacro mappings([do: block]) do
    mappings =  [properties: extract(block)]
    quote do
      var!(index) = var!(index) ++ [mapping: unquote(mappings)]
    end
  end

  def indexes(options) do
    case options do
      [name, options] ->
        if options[:do] != nil do
          block = options
          options = [type: "object"]
          Dict.put([], to_atom(name), options ++ [properties: extract(block[:do])])
        else
          Dict.put([], to_atom(name), options)
        end
      [name, options, block] ->
        Dict.put([], to_atom(name), options ++ [properties: extract(block[:do])])
    end
  end

end