Code.require_file "../../test_helper.exs", __ENV__.file
defmodule Tirexs.SearchTest do
  use ExUnit.Case
  import Tirexs.Search

  test :search_with_query_and_filter do
    search = Tirexs.Search.search do
      query do
        term "tag", "wow"
      end

      filter do
        term "filter_tag", "wwoww"
      end
    end

    assert search == [search: [query: [term: [tag: "wow"]], filter: [term: [filter_tag: "wwoww"]]]]
  end

  test :search_with_facets do
    search = search do
      query do
        term "tag", "wow"
      end

      filter do
        term "filter_tag", "wwoww"
      end

      facets do
        tagFacet do
          terms field: "tag", size: 10, order: "term"
        end
        keywordFacet do
          terms field: "keywords", all_terms: true
        end
      end
    end

    assert search == [search: [query: [term: [tag: "wow"]], filter: [term: [filter_tag: "wwoww"]], facets: [tagFacet: [terms: [field: "tag", size: 10, order: "term"]], keywordFacet: [terms: [field: "keywords", all_terms: true]]]]]
  end

  test :complete_search do
    search = search [from: 0, size: 10, fields: [:tag, :article], explain: 5, version: true, min_score: 0.5] do
      query do
        term "tag", "wow"
      end

      filter do
        term "filter_tag", "wwoww"
      end

      facets do
        tagFacet do
          terms field: "tag", size: 10, order: "term"
        end
        keywordFacet do
          terms field: "keywords", all_terms: true
        end
      end

      highlight do
        [
          number_of_fragments: 3,
          fragment_size: 150,
          tag_schema: "styled"
        ]
      end

      suggest do
        my_suggest_1 do
          fuzzy "field", "body"
        end
      end

      sort do
        [
          [post_date: [reverse: true]],
          [name: "desc"],
          [age: "desc"]
        ]
      end

      rescore [window_size: 50] do
        query [query_weight: 0.7, rescore_query_weight: 1.2] do
          rescore_query do
            match "field1", "the quick brown", [type: "phrase", slop: 2]
          end
        end
      end

      script_fields do
        [
          test1: [script: "doc['my_field_name'].value * 2"],
          test2: [script: "doc['my_field_name'].value * factor", params: [factor: 2]]
        ]
      end

    end

      assert search == [search: [query: [term: [tag: "wow"]], filter: [term: [filter_tag: "wwoww"]], facets: [tagFacet: [terms: [field: "tag", size: 10, order: "term"]], keywordFacet: [terms: [field: "keywords", all_terms: true]]], highlight: [number_of_fragments: 3, fragment_size: 150, tag_schema: "styled"], suggest: [my_suggest_1: [fuzzy: [field: "body"]]], sort: [[post_date: [reverse: true]],[name: "desc"],[age: "desc"]], rescore: [query: [rescore_query: [match: [field1: [query: "the quick brown", type: "phrase", slop: 2]]], query_weight: 0.7, rescore_query_weight: 1.2], window_size: 50], script_fields: [test1: [script: "doc['my_field_name'].value * 2"], test2: [script: "doc['my_field_name'].value * factor", params: [factor: 2]]], from: 0, size: 10, fields: [:tag,:article], explain: 5, version: true, min_score: 0.5]]



  end
end
