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
        aggs do
          agg_name do
            terms [field: "gender"]
          end
        end
      end
    end

    expected = [aggs: [shit: [filter: [term: [user: "mvg"]], aggs: [agg_name: [terms: [field: "gender"]]]]]]
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

  test "nested" do
    actual = aggs do
      aggs1 do
        nested [path: "obj1"]
        aggs do
          aggs1 do
            terms [field: "obj1.name"]
          end
        end
      end
    end

    expected = [aggs: [aggs1: [nested: [path: "obj1"], aggs: [aggs1: [terms: [field: "obj1.name"]]]]]]
    assert actual == expected
  end

  test "complex nested" do
    actual = aggs do
      nested_obj1 do
        nested [path: "obj1"]
        aggs do
          color_filter do
            filter do
              term "obj1.color", "blue"
            end
            aggs do
              name_terms do
                terms [field: "obj1.name"]
              end
            end
          end
        end
      end
    end

    expected = [aggs: [nested_obj1: [nested: [path: "obj1"], aggs: [color_filter: [filter: [term: ['obj1.color': "blue"]], aggs: [name_terms: [terms: [field: "obj1.name"]]]]]]]]
    assert actual == expected
  end
end
