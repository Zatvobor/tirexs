Code.require_file "../../test_helper.exs", __ENV__.file

defmodule Tirexs.QueryTest do
  use ExUnit.Case

  import Tirexs.Query


  test "query w/ match" do
    query = query do
      match "message", "this is a test", operator: "and"
    end

    expected = [query: [match: [message: [query: "this is a test", operator: "and"]]]]
    assert query == expected
  end

  test "query w/ range" do
    query = query do
      range "age", from: 10,
                   to: 20,
                   include_lower: true,
                   include_upper: false,
                   boost: 2.0
    end

    expected = [query: [range: [age: [from: 10, to: 20, include_lower: true, include_upper: false, boost: 2.0]]]]
    assert query == expected
  end

  test "query w/ match_phrase" do
    query = query do
      match_phrase "message", "this phrase"
    end
    expected = [query: [match_phrase: [message: "this phrase"]]]
    assert query == expected
  end

  test "query w/ match_phrase_prefix" do
    query = query do
      match_phrase_prefix "message", "this phrase"
    end
    expected = [query: [match_phrase_prefix: [message: "this phrase"]]]
    assert query == expected
  end

  test "query w/ multi_match" do
    query = query do
      multi_match "this is a test", ["subject", "message"]
    end

    expected = [query: [multi_match: [query: "this is a test", fields: ["subject","message"]]]]
    assert query == expected
  end

  test "query w/ ids" do
    query = query do
      ids "my_type", ["1", "4", "100"]
    end

    expected = [query: [ids: [type: "my_type", values: ["1","4","100"]]]]
    assert query == expected
  end

  test "query w/ query_string" do
    query = query do
      query_string "this AND that OR thus", [default_field: "content"]
    end

    expected = [query: [query_string: [query: "this AND that OR thus", default_field: "content"]]]
    assert query == expected
  end

  test "query w/ string" do
    query = query do
      string "this AND that OR thus", [default_field: "content"]
    end

    expected = [query: [query_string: [query: "this AND that OR thus", default_field: "content"]]]
    assert query == expected
  end

  test "query w/ custom_score" do
    query = query do
      custom_score [script: "_score * doc[\"type\"].value"] do
        query do
          query_string "this AND that OR thus", [default_field: "artist_name"]
        end
      end
    end

    expected = [query: [custom_score: [query: [query_string: [query: "this AND that OR thus", default_field: "artist_name"]], script: "_score * doc[\"type\"].value"]]]
    assert query == expected
  end

  test "query w/ custom_boost_factor" do
    query = query do
      custom_boost_factor [boost_factor: 5.2] do
        query do
          query_string "this AND that OR thus", [default_field: "artist_name"]
        end
      end
    end

    expected = [query: [custom_boost_factor: [query: [query_string: [query: "this AND that OR thus", default_field: "artist_name"]], boost_factor: 5.2]]]
    assert query == expected
  end

  test "query w/ constant_score" do
    query = query do
      constant_score [boost: 1.2] do
        query do
          query_string "this AND that OR thus", [default_field: "artist_name"]
        end
      end
    end

    expected = [query: [constant_score: [query: [query_string: [query: "this AND that OR thus", default_field: "artist_name"]], boost: 1.2]]]
    assert query == expected
  end

  test "query w/ field" do
    query = query do
      field "name.first", [query: "+something -else", boost: 2.0, enable_position_increments: false]
    end

    expected = [query: [field: ["name.first": [query: "+something -else", boost: 2.0, enable_position_increments: false]]]]
    assert query == expected
  end

  test "query w/ flt" do
    query = query do
      flt "text like this one", ["name.first", "name.last"], max_query_terms: 12
    end

    expected = [query: [fuzzy_like_this: [like_text: "text like this one", fields: ["name.first","name.last"], max_query_terms: 12]]]
    assert query == expected
  end

  test "query w/ flt_field" do
    query = query do
      flt_field "name.first", [like_text: "text like this one", max_query_terms: 12]
    end

    expected = [query: [fuzzy_like_this_field: ["name.first": [like_text: "text like this one", max_query_terms: 12]]]]
    assert query == expected
  end

  test "query w/ fuzzy" do
    query = query do
      fuzzy "user", "ki"
    end

    expected = [query: [fuzzy: [user: "ki"]]]
    assert query == expected
  end

  test "query w/ fuzzy_with_opts" do
    query = query do
      fuzzy "user", [value: "ki", boost: 1.0, min_similarity: 0.5, prefix_length: 0]
    end

    expected = [query: [fuzzy: [user: [value: "ki", boost: 1.0, min_similarity: 0.5, prefix_length: 0]]]]
    assert query == expected
  end

  test "query w/ has_child" do
    query = query do
      has_child [type: "blog_tag", score_type: "sum"] do
        query do
          term "tag", "something"
        end
      end
    end

    expected = [query: [has_child: [query: [term: [tag: "something"]], type: "blog_tag", score_type: "sum"]]]
    assert query == expected
  end

  test "query w/ has_parent" do
    query = query do
      has_parent [parent_type: "blog", score_type: "score"] do
        query do
          term "tag", "something"
        end
      end
    end

    expected = [query: [has_parent: [query: [term: [tag: "something"]], parent_type: "blog", score_type: "score"]]]
    assert query == expected
  end

  test "query w/ match_all" do
    query = query do
      match_all
    end

    assert query == [query: [match_all: []]]
  end

  test "query w/ match_all_with_options" do
    query = query do
      match_all norms_field: "my_field", boost: 1.2
    end

    assert query == [query: [match_all: [norms_field: "my_field", boost: 1.2]]]
  end

  test "query w/ mlt" do
    query = query do
      mlt "text like this one", ["name.first", "name.last"], min_term_freq: 1
    end

    expected = [query: [more_like_this: [like_text: "text like this one", fields: ["name.first","name.last"], min_term_freq: 1]]]
    assert query == expected
  end

  test "query w/ mlt_field" do
    query = query do
      mlt_field "name.first", [like_text: "text like this one", min_term_freq: 1]
    end

    expected = [query: [more_like_this_field: ["name.first": [like_text: "text like this one", min_term_freq: 1]]]]
    assert query == expected
  end

  test "query w/ prefix" do
    query = query do
      prefix "user", "ki"
    end

    expected = [query: [prefix: [user: "ki"]]]
    assert query == expected
  end

  test "query w/ span_first" do
    query = query do
      span_first  [end: 3] do
        match do
          span_term "user", "kimchy"
        end
      end
    end

    expected = [query: [span_first: [match: [span_term: [user: "kimchy"]], end: 3]]]
    assert query == expected
  end

  test "query w/ span_near" do
    query = query do
      span_near [slop: 12, in_order: false, collect_payloads: false] do
        clauses do
          span_term "field", "value1"
          span_term "field", "value2"
          span_term "field", "value3"
        end
      end
    end

    expected = [query: [span_near: [clauses: [[span_term: [field: "value1"]],[span_term: [field: "value2"]],[span_term: [field: "value3"]]], slop: 12, in_order: false, collect_payloads: false]]]
    assert query == expected
  end

  test "query w/ span_not" do
    query = query do
      span_not do
        include do
          span_term "field", "value1"
        end
        exclude do
          span_term "field", "value2"
        end
      end
    end

    expected = [query: [span_not: [include: [span_term: [field: "value1"]], exclude: [span_term: [field: "value2"]]]]]
    assert query == expected
  end

  test "query w/ span_or" do
    query = query do
      span_or do
        clauses do
          span_term "field", "value1"
          span_term "field", "value2"
          span_term "field", "value3"
        end
      end
    end

    expected = [query: [span_or: [clauses: [[span_term: [field: "value1"]],[span_term: [field: "value2"]],[span_term: [field: "value3"]]]]]]
    assert query == expected
  end

  test "query w/ span_multi" do
    query = query do
      span_multi do
        fuzzy "user", [value: "ki", boost: 1.0, min_similarity: 0.5, prefix_length: 0]
      end
    end

    expected = [query: [span_multi: [fuzzy: [user: [value: "ki", boost: 1.0, min_similarity: 0.5, prefix_length: 0]]]]]
    assert query == expected
  end

  test "query w/ span_term" do
    query = query do
      span_term "field", [value: "value1", boost: 2.0]
    end

    assert query == [query: [span_term: [field: [value: "value1", boost: 2.0]]]]
  end

  test "query w/ terms" do
    query = query do
      terms "tags", ["blue", "pill"], minimum_match: 1
    end

    assert query == [query: [terms: [tags: ["blue","pill"], minimum_match: 1]]]
  end

  test "query w/ top_children" do
    query = query do
      top_children [type: "blog_tag", score: "max", factor: 5, incremental_factor: 2] do
        query do
          term "tag", "something"
        end
      end
    end

    expected = [query: [top_children: [query: [term: [tag: "something"]], type: "blog_tag", score: "max", factor: 5, incremental_factor: 2]]]
    assert query == expected
  end

  test "query w/ wildcard" do
    query = query do
      wildcard "user", "ki*y"
    end

    expected = [query: [wildcard: [user: "ki*y"]]]
    assert query == expected
  end

  test "query w/ indices and no_match_query" do
    query = query do
      indices [indices: ["index1", "index2"]] do
        query do
          term "tag", "wow"
        end
        no_match_query do
          term "tag", "kow"
        end
      end
    end

    expected = [query: [indices: [query: [term: [tag: "wow"]], no_match_query: [term: [tag: "kow"]], indices: ["index1","index2"]]]]
    assert query == expected
  end

  test "query w/ indices and no_match_query w/ none" do
    query = query do
      indices [indices: ["index1", "index2"]] do
        query do
          term "tag", "wow"
        end
        no_match_query do
          "none"
        end
      end
    end

    expected = [query: [indices: [query: [term: [tag: "wow"]], no_match_query: "none", indices: ["index1","index2"]]]]
    assert query == expected
  end

  test "query w/ text" do
    query = query do
      text "message", "this is a test"
    end

    expected = [query: [text: [message: "this is a test"]]]
    assert query == expected
  end

  test "query w/ text_phrase" do
    query = query do
      text_phrase "message", "this is a test"
    end

    expected = [query: [text_phrase: [message: "this is a test"]]]
    assert query == expected
  end

  test "query w/ text_phrase_prefix" do
    query = query do
      text_phrase_prefix "message", [query: "this is a test", max_expansions: 10]
    end

    expected = [query: [text_phrase_prefix: [message: [query: "this is a test", max_expansions: 10]]]]
    assert query == expected
  end

  test "query w/ geo_shape" do
    query = query do
      geo_shape do
        location [relation: "contains"] do
          shape [type: "type", coordinates: [[-45.0, 45.0], [45.0, -45.0]]]
        end
      end
    end

    expected = [query: [geo_shape: [location: [shape: [type: "type", coordinates: [[-45.0,45.0],[45.0,-45.0]]], relation: "contains"]]]]
    assert query == expected
  end

  test "query w/ filtered" do
    query = query do
      filtered do
        query do
          term "tag", "wow"
        end
        filter do
          range "age", [from: 10, to: 20]
        end
      end
    end

    expected = [query: [filtered: [query: [term: [tag: "wow"]], filter: [range: [age: [from: 10, to: 20]]]]]]
    assert query == expected
  end

  test "query w/ nested" do
    query = query do
      nested [path: "obj1", _cache: true] do
        query do
          bool do
            must do
              match "obj1.name", "blue"
              range "obj1.count", [gt: 5]
            end
          end
        end
      end
    end

    expected = [query: [nested: [query: [bool: [must: [[match: ["obj1.name": [query: "blue"]]],[range: ["obj1.count": [gt: 5]]]]]], path: "obj1", _cache: true]]]
    assert query == expected
  end

  test "query w/ custom_filters_score" do
    query = query do
      custom_filters_score [score_mode: "first"] do
        query do
          match_all
        end
        filters do
          group do
            filter do
              range "age", [from: 0, to: 10]
            end
            boost 1
          end
          group do
            filter do
              range "age", [from: 0, to: 10]
            end
            boost 2
          end
        end
      end
    end

    expected = [query: [custom_filters_score: [filters: [[filter: [range: [age: [from: 0, to: 10]]], boost: 1],[filter: [range: [age: [from: 0, to: 10]]], boost: 2]], query: [match_all: []], score_mode: "first"]]]
    assert query == expected
  end

  test "query w/ function_score" do
    query = query do
      function_score do
        query do
          match_all
        end
        field_value_factor do
          field "votes"
          modifier "log1p"
          factor 2.0
        end
        boost_mode "sum"
        max_boost 1.5
        min_score 0.8
      end
    end

    expected = [query: [function_score: [query: [match_all: []], field_value_factor: [field: "votes", modifier: "log1p", factor: 2.0], boost_mode: "sum", max_boost: 1.5, min_score: 0.8]]]
    assert query == expected
  end
end
