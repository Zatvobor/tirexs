defmodule Tirexs.Search.AggsTest do
  use ExUnit.Case

  import Tirexs.Search.Aggs


  test "simple case" do
    actual = aggs do
      wow do
        filter do
          term "tag", "wow"
        end
      end
    end

    expected = [aggs: [wow: [filter: [term: [tag: "wow"]]]]]
    assert actual == expected
  end

  test "filter aggregation w/ query string" do
    actual = aggs do
      omg do
        filter do
          query do
            query_string "tag:wow"
          end
        end
      end
    end

    expected = [aggs: [omg: [filter: [query: [query_string: [query: "tag:wow"]]]]]]
    assert actual == expected
  end

  test "filter aggregation" do
    actual = aggs do
      shit do
        filter do
          term "user", "mvg"
        end
      end
    end

    expected = [aggs: [shit: [filter: [term: [user: "mvg"]]]]]
    assert actual == expected
  end

  test "term stats" do
    actual = aggs do
      term_stats [field: "tag"], [field: "price"]
    end

    expected = [aggs: [tags: [terms: [field: "tag"], aggs: [price_stats: [stats: [field: "price"]]]]]]
    assert actual == expected
  end

  test "value field" do
    actual = aggs do
      histo1 do
        date_histogram field: "timestamp", interval: "day"
        stats [field: "price"]
      end
    end

    expected = [aggs: [histo1: [date_histogram: [field: "timestamp", interval: "day"], aggs: [price_stats: [stats: [field: "price"]]]]]]
    assert actual == expected
  end
end
