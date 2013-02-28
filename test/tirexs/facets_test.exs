Code.require_file "../../test_helper.exs", __FILE__
defmodule FacetsTest do
  use ExUnit.Case
  import Tirexs
  use Tirexs.Facets
  use Tirexs.ElasticSettings

  test :simple_facets_dsl do
    facets = facets do
      tagFacet do
        terms field: "tag", size: 10, order: "term"
      end
      # keywordFacet do
      #   terms field: "keywords", all_terms: true
      # end
    end

    assert facets == [facets: [tagFacet: [terms: [field: "tag", size: 10, order: "term"]]]]
  end

  test :multi_facets do
    facets = facets do
      tagFacet do
        terms field: "tag", size: 10, order: "term"
      end
      keywordFacet do
        terms field: "keywords", all_terms: true
      end
    end

    assert facets == [facets: [tagFacet: [terms: [field: "tag", size: 10, order: "term"]], keywordFacet: [terms: [field: "keywords", all_terms: true]]]]
  end
end