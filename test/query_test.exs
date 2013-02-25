Code.require_file "../test_helper.exs", __FILE__
defmodule QueryTest do
  use ExUnit.Case
  import Tirexs
  use Tirexs.Query

  test :match_query do
    query = query do
      match "message", "this is a test", operator: "and"
    end
    assert query == [query: [match: [message: [query: "this is a test", operator: "and"]]]]
  end

  test :range_query do
    query = query do
      range "age", from: 10,
                   to: 20,
                   include_lower: true,
                   include_upper: false,
                   boost: 2.0
    end
    assert query == [query: [range: [age: [from: 10, to: 20, include_lower: true, include_upper: false, boost: 2.0]]]]
  end

  # test :multi_match do
  #     query = query do
  #       bool do
  #         must do
  #           multi_match "this is a test", ["subject", "message"]
  #         end
  #       end
  #     end
  #     assert query == [query: [bool: [must: [[multi_match: [query: "this is a test", fields: ["subject","message"]]]]]]]
  #   end

end
