Code.require_file "../../../test_helper.exs", __ENV__.file

defmodule Tirexs.Search.AggregationsTest do
  use ExUnit.Case

  import Tirexs.Search.Aggregations


  test "simple case" do
    aggs = aggs do
      wow do
        filter do
          term "tag", "wow"
        end
      end
    end

    expected = [aggs: [wow: [filter: [term: [tag: "wow"]]]]]
    assert aggs == expected
  end
end
