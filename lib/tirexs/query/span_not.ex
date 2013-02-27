defmodule Tirexs.Query.SpanNot do
  import Tirexs.Query.Helpers

  def include(options) do
    [include: extract(options[:do])]
  end

  def exclude(options) do
    [exclude: extract(options[:do])]
  end
end