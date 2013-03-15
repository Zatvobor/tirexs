Code.require_file "../../../test_helper.exs", __FILE__
defmodule WarmerTest do
  use ExUnit.Case
  import Tirexs.Search.Warmer

  test :create_warmer do
    warmers = warmers do
      warmer_1 [types: []] do
        source do
          query do
            term "user", "kim"
          end
          facets do
            tagFacet do
              terms field: "tag", size: 10, order: "term"
            end
          end
        end
      end
    end

    assert warmers == [warmers: [warmer_1: [source: [query: [term: [user: "kim"]], facets: [tagFacet: [terms: [field: "tag", size: 10, order: "term"]]]], types: []]]]

  end
end