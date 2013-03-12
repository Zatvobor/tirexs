Code.require_file "../../test_helper.exs", __FILE__
defmodule FacetsTest do
  use ExUnit.Case
  import Tirexs.Facets

  test :simple_facets_dsl do
    facets = facets do
      tagFacet [path: "nested"] do
        terms field: "tag", size: 10, order: "term"
      end
    end

    assert facets == [facets: [tagFacet: [terms: [field: "tag", size: 10, order: "term"], path: "nested"]]]
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

  test :range do
    facets = facets do
      range1 do
        range field: "field_name", ranges: [[to: 50 ],
                                            [from: 20, to: 70 ],
                                            [from: 70, to: 120 ],
                                            [from: 150]]
      end
    end

    assert facets == [facets: [range1: [range: [field: "field_name", ranges: [[to: 50],[from: 20, to: 70],[from: 70, to: 120],[from: 150]]]]]]
  end

  test :histogram do
    facets = facets do
      histo1 do
        histogram key_script: "doc['date'].date.minuteOfHour", value_script: "doc['num1'].value", params: [factor1: 2, factor2: 6]
      end
    end

    assert facets == [facets: [histo1: [histogram: [key_script: "doc['date'].date.minuteOfHour", value_script: "doc['num1'].value", params: [factor1: 2, factor2: 6]]]]]
  end

  test :date_histogram do
    facets = facets do
      histo1 do
        date_histogram field: "field_name", interval: "day", value_script: "doc['price'].value * 2"
      end
    end

    assert facets == [facets: [histo1: [date_histogram: [field: "field_name", interval: "day", value_script: "doc['price'].value * 2"]]]]
  end

  test :statistical do
    facets = facets do
      stat1 do
        statistical script: "(doc['num1'].value + doc['num2'].value) * factor", params: [factor: 5]
      end
    end

    assert facets == [facets: [stat1: [statistical: [script: "(doc['num1'].value + doc['num2'].value) * factor", params: [factor: 5]]]]]
  end

  test :terms_stats do
    facets = facets do
      tag_price_stats do
        terms_stats key_field: "tag", value_field: "price"
      end
    end

    assert facets == [facets: [tag_price_stats: [terms_stats: [key_field: "tag", value_field: "price"]]]]
  end

  test :geo_distance do
    ranges = [[to: 10],[from: 20, to: 10],[from: 20, to: 100],[from: 100]]
    facets = facets do
      geo1 do
        geo_distance ["pin.location": [lat: 40, lon: 70], ranges: ranges]
      end
    end

    assert facets == [facets: [geo1: [geo_distance: ["pin.location": [lat: 40, lon: 70], ranges: [[to: 10],[from: 20, to: 10],[from: 20, to: 100],[from: 100]]]]]]
  end

  test :filter do
    facets = facets do
      wow do
        filter do
          term "tag", "wow"
        end
      end
    end

    assert facets == [facets: [filter: [term: [tag: "wow"]]]]
  end

  test :query do
    facets = facets do
      wow_facet do
        query do
          term "tag", "wow"
        end
      end
    end

    assert facets == [facets: [query: [term: [tag: "wow"]]]]
  end

  test :facet_filter do
    facets = facets do
      facet1 [nested: "obj"] do
        terms_stats key_field: "name", value_field: "count"
        facet_filter do
          term "name", "blue"
        end
      end
    end

    assert facets == [facets: [facet1: [terms_stats: [key_field: "name", value_field: "count"], facet_filter: [term: [name: "blue"]], nested: "obj"]]]
  end

end