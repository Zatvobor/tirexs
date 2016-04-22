defmodule Tirexs.Search.WarmerTest do
  use ExUnit.Case

  import Tirexs.Search.Warmer


  test "index warmers" do
    warmers = warmers do
      warmer_1 [types: []] do
        source do
          query do
            term "user", "kim"
          end
          aggs do
            aggs_name do
              terms [field: "tag", size: 10, order: "term"]
            end
          end
        end
      end
    end

    expected = [warmers: [warmer_1: [source: [query: [term: [user: "kim"]], aggs: [aggs_name: [terms: [field: "tag", size: 10, order: "term"]]]], types: []]]]
    assert warmers == expected
  end
end
