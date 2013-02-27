Code.require_file "../test_helper.exs", __FILE__
defmodule FilterTest do
  use ExUnit.Case
  import Tirexs
  use Tirexs.Filter
  use Tirexs.ElasticSettings

  test :filter do
    query = filter do
      term "tag", "green"
    end

    assert query == [filter: [term: [tag: "green"]]]
  end

  test :exists do
    query = filter do
      exists "id"
    end

    assert query == [filter: [exists: [field: "id"]]]
  end

  test :filtered do
    query = filter do
      filtered do
        query do
          query_string "elasticsearch", default_field: "message"
        end
        filter do
          bool do
            must do
              term "tag", "wow"
            end
            must_not do
              range "age", [from: 10, to: 20]
            end
            should do
              term "tag", "sometag"
              term "tag", "sometagtag"
            end
          end
        end
      end
    end

    assert query == [filter: [filtered: [query: [query_string: [query: "elasticsearch", default_field: "message"]], filter: [bool: [must: [[term: [tag: "wow"]]], must_not: [[range: [age: [from: 10, to: 20]]]], should: [[term: [tag: "sometag"]],[term: [tag: "sometagtag"]]]]]]]]
  end

end