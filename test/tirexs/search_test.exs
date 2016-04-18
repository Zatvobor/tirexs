defmodule Tirexs.SearchTest do
  use ExUnit.Case

  import Tirexs.Search


  test "search w/ query, filter" do
    search = search do
      query do
        term "tag", "wow"
      end

      filter do
        term "filter_tag", "wwoww"
      end
    end

    expected = [search: [query: [term: [tag: "wow"]], filter: [term: [filter_tag: "wwoww"]]]]
    assert search == expected
  end

  test "search w/ query, size, from" do
    search = search do
      query do
        term "tag", "wow"
      end

      size 25
      from 50
    end

    expected = [search: [query: [term: [tag: "wow"]], size: 25, from: 50]]
    assert search == expected
  end
end
