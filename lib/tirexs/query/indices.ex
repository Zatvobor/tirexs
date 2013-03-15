defmodule Tirexs.Query.Indices do

  import Tirexs.Query.Helpers
  import Tirexs.DSL.Logic

  def no_match_query(options) when is_binary(options) do
    [no_match_query: options]
  end

  def no_match_query(options) do
    [no_match_query: extract(options)]
  end
end