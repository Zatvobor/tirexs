defmodule Tirexs.Facets do
  import Tirexs.Helpers
  import Tirexs.Facets.Helpers

  defmacro __using__(_) do
    quote do
      import unquote(Tirexs.Facets)
    end
  end

  defmacro facets([do: block]) do
    # IO.puts inspect(block)
    [facets: extract(block)]
  end

  def make_facet(name, options) do
    Dict.put([], to_atom(name), options[:do])
  end

  def terms(options) do
    [terms: options]
  end

end