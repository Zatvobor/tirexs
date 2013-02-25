defmodule Tirexs.Query.Bool do

  import Tirexs.Query.Helpers
  import Tirexs.Query
  import Tirexs.Helpers

  defmacro __using__(_) do
      quote do
        import unquote(Tirexs.Query.Bool)
      end
    end

  def bool(block) do
    [bool: scoped_query(block)]
  end

  def must(block) do
    # IO.puts inspect to_bool_array(scoped_query(block))
    [must: to_bool_array(scoped_query(block))]
  end

  def should(block) do
    [should: to_bool_array(scoped_query(block))]
  end

  def must_not(block) do
    [must_not: to_bool_array(scoped_query(block))]
  end

  defp to_bool_array(dict) do
    to_bool_array(dict, [])
  end

  defp to_bool_array([], acc) do
    acc
  end

  defp to_bool_array([h|t], acc) do
    to_bool_array(t, acc ++ [[h]])
  end



end