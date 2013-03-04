Code.require_file "../../../test_helper.exs", __FILE__
defmodule Filter.Methods.Test do
  use ExUnit.Case
  use Tirexs.Filter
  import Tirexs.Filter.Methods
  use Tirexs.Search

  test :join do
    filters = []
    filters = filters ++ [query: [term: [id: "1"]]]
    filters = filters ++ [query: [term: [id: "4"]]]

    assert Tirexs.Filter.Methods.join(:and, filters) == [and: [filters: [[query: [term: [id: "1"]]],[query: [term: [id: "4"]]]]]]
    assert Tirexs.Filter.Methods.join(:or, filters) == [or: [filters: [[query: [term: [id: "1"]]],[query: [term: [id: "4"]]]]]]
  end

  test :search_with_join_filters do
    filters = []
    filters = filters ++ [query: [term: [id: "1"]]]
    filters = filters ++ [query: [term: [id: "4"]]]

    search = search do
      query do
        term "tag", "wow"
      end
      filters Tirexs.Filter.Methods.join(:and, filters)
    end

    assert search == [search: [query: [term: [tag: "wow"]], filter: [and: [filters: [[query: [term: [id: "1"]]],[query: [term: [id: "4"]]]]]]]]
  end
end