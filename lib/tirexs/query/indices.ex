defmodule Tirexs.Query.Indeces do
  import Tirexs.Query.Helpers
  import Tirexs.Helpers

  def no_match_query(options) do
    case is_binary(options) do
      true -> [no_match_query: options]
      false -> [no_match_query: extract(options)]
    end

  end
end