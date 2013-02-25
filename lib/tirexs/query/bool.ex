defmodule Tirexs.Query.Bool do

  import Tirexs.Query.Helpers
  import Tirexs.Query
  import Tirexs.Helpers

  defmacro __using__(_) do
      quote do
        import unquote(Tirexs.Query.Bool)
      end
    end

  defmacro bool([do: block]) do
    [bool: convert_bool_query(scoped_query(block))]
  end

  def must(block) do
    [must: scoped_query(block)]
  end

  def should(block) do
    [should: scoped_query(block)]
  end

  def must_not(block) do
    [must_not: scoped_query(block)]
  end

end