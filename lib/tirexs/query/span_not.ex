defmodule Tirexs.Query.SpanNot do
  import Tirexs.Query.Helpers

  def include(options) do
    [include: scoped_query(options[:do])]
  end

  def exclude(options) do
    [exclude: scoped_query(options[:do])]
  end
end