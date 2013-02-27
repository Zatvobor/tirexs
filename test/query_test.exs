Code.require_file "../test_helper.exs", __FILE__
defmodule QueryTest do
  use ExUnit.Case
  import Tirexs
  use Tirexs.Query
  use Tirexs.ElasticSettings

  test :match_query do
    query = query do
      match "message", "this is a test", operator: "and"
    end

    assert query == [query: [match: [message: [query: "this is a test", operator: "and"]]]]
  end

  test :range_query do
    query = query do
      range "age", from: 10,
                   to: 20,
                   include_lower: true,
                   include_upper: false,
                   boost: 2.0
    end

    assert query == [query: [range: [age: [from: 10, to: 20, include_lower: true, include_upper: false, boost: 2.0]]]]
  end

  test :multi_match do
    query = query do
      multi_match "this is a test", ["subject", "message"]
    end

    assert query == [query: [multi_match: [query: "this is a test", fields: ["subject","message"]]]]
  end

  test :ids do
    query = query do
      ids "my_type", ["1", "4", "100"]
    end

    assert query == [query: [ids: [type: "my_type", values: ["1","4","100"]]]]
  end

  test :query_string do
    query = query do
      query_string "this AND that OR thus", [default_field: "content"]
    end

    assert query == [query: [query_string: [query: "this AND that OR thus", default_field: "content"]]]
  end

  test :custom_score do
    query = query do
      custom_score [script: "_score * doc[\"type\"].value"] do
        query do
          query_string "this AND that OR thus", [default_field: "artist_name"]
        end
      end
    end

    assert query == [query: [custom_score: [query: [query_string: [query: "this AND that OR thus", default_field: "artist_name"]], script: "_score * doc[\"type\"].value"]]]
  end

  test :custom_boost_factor do
    query = query do
      custom_boost_factor [boost_factor: 5.2] do
        query do
          query_string "this AND that OR thus", [default_field: "artist_name"]
        end
      end
    end

    assert query == [query: [custom_boost_factor: [query: [query_string: [query: "this AND that OR thus", default_field: "artist_name"]], boost_factor: 5.2]]]
  end

  test :constant_score do
    query = query do
      constant_score [boost: 1.2] do
        query do
          query_string "this AND that OR thus", [default_field: "artist_name"]
        end
      end
    end

    assert query == [query: [constant_score: [query: [query_string: [query: "this AND that OR thus", default_field: "artist_name"]], boost: 1.2]]]
  end

  test :field do
    query = query do
      field "name.first", [query: "+something -else", boost: 2.0, enable_position_increments: false]
    end

    assert query == [query: [field: ["name.first": [query: "+something -else", boost: 2.0, enable_position_increments: false]]]]
  end

  test :flt do
    query = query do
      flt "text like this one", ["name.first", "name.last"], max_query_terms: 12
    end

    assert query == [query: [fuzzy_like_this: [like_text: "text like this one", fields: ["name.first","name.last"], max_query_terms: 12]]]
  end

  test :flt_field do
    query = query do
      flt_field "name.first", [like_text: "text like this one", max_query_terms: 12]
    end

    assert query == [query: [fuzzy_like_this_field: ["name.first": [like_text: "text like this one", max_query_terms: 12]]]]
  end

  test :fuzzy do
    query = query do
      fuzzy "user", "ki"
    end

    assert query == [query: [fuzzy: [user: "ki"]]]
  end

  test :fuzzy_with_opts do
    query = query do
      fuzzy "user", [value: "ki", boost: 1.0, min_similarity: 0.5, prefix_length: 0]
    end

    assert query == [query: [fuzzy: [user: [value: "ki", boost: 1.0, min_similarity: 0.5, prefix_length: 0]]]]
  end

  test :has_child do
    query = query do
      has_child [type: "blog_tag", score_type: "sum"] do
        query do
          term "tag", "something"
        end
      end
    end

    assert query == [query: [has_child: [query: [term: [tag: "something"]], type: "blog_tag", score_type: "sum"]]]
  end

  test :has_parent do
    query = query do
      has_parent [parent_type: "blog", score_type: "score"] do
        query do
          term "tag", "something"
        end
      end
    end

    assert query == [query: [has_parent: [query: [term: [tag: "something"]], parent_type: "blog", score_type: "score"]]]
  end

  test :match_all do
    query = query do
      match_all
    end

    assert query == [query: [match_all: []]]
  end

  test :match_all_with_options do
    query = query do
      match_all norms_field: "my_field", boost: 1.2
    end

    assert query == [query: [match_all: [norms_field: "my_field", boost: 1.2]]]
  end

  test :mlt do
    query = query do
      mlt "text like this one", ["name.first", "name.last"], min_term_freq: 1
    end

    assert query == [query: [more_like_this: [like_text: "text like this one", fields: ["name.first","name.last"], min_term_freq: 1]]]
  end

  test :mlt_field do
    query = query do
      mlt_field "name.first", [like_text: "text like this one", min_term_freq: 1]
    end

    assert query == [query: [more_like_this_field: ["name.first": [like_text: "text like this one", min_term_freq: 1]]]]
  end

  test :prefix do
    query = query do
      prefix "user", "ki"
    end

    assert query == [query: [prefix: [user: "ki"]]]
  end

  test :span_first do
    query = query do
      span_first  [end: 3] do
        match do
          span_term "user", "kimchy"
        end
      end
    end

    assert query == [query: [span_first: [match: [span_term: [user: "kimchy"]], end: 3]]]
  end

  test :span_near do
    query = query do
        span_near [slop: 12, in_order: false, collect_payloads: false] do
          clauses do
            span_term "field", "value1"
            span_term "field", "value2"
            span_term "field", "value3"
          end
        end
      end

    assert query == [query: [span_near: [clauses: [[span_term: [field: "value1"]],[span_term: [field: "value2"]],[span_term: [field: "value3"]]], slop: 12, in_order: false, collect_payloads: false]]]
  end

  test :span_not do
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

    assert query == [query: [span_not: [include: [span_term: [field: "value1"]], exclude: [span_term: [field: "value2"]]]]]
  end

  test :span_or do
    query = query do
          span_or do
            clauses do
              span_term "field", "value1"
              span_term "field", "value2"
              span_term "field", "value3"
            end
          end
        end

    assert query == [query: [span_or: [clauses: [[span_term: [field: "value1"]],[span_term: [field: "value2"]],[span_term: [field: "value3"]]]]]]
  end

  test :span_term do
    query = query do
      span_term "field", [value: "value1", boost: 2.0]
    end

    assert query == [query: [span_term: [field: [value: "value1", boost: 2.0]]]]
  end

  test :terms do
    query = query do
      terms "tags", ["blue", "pill"], minimum_match: 1
    end

    assert query == [query: [terms: [tags: ["blue","pill"], minimum_match: 1]]]
  end

  test :top_children do
    query = query do
      top_children [type: "blog_tag", score: "max", factor: 5, incremental_factor: 2] do
        query do
          term "tag", "something"
        end
      end
    end

    assert query == [query: [top_children: [query: [term: [tag: "something"]], type: "blog_tag", score: "max", factor: 5, incremental_factor: 2]]]
    # settings = elastic_settings.new([port: 80, uri: "api.tunehog.com/kiosk-rts"])
    # IO.puts inspect(do_query(settings, "labeled/track", query))
  end

  test :wildcard do
    query = query do
      wildcard "user", "ki*y"
    end

    assert query == [query: [wildcard: [user: "ki*y"]]]
  end

  test :indices do
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

    assert query == [query: [indices: [query: [term: [tag: "wow"]], no_match_query: [term: [tag: "kow"]], indices: ["index1","index2"]]]]
  end

  test :indices_with_default do
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

    assert query == [query: [indices: [query: [term: [tag: "wow"]], no_match_query: "none", indices: ["index1","index2"]]]]
  end

  test :text do
    query = query do
      text "message", "this is a test"
    end

    assert query == [query: [text: [message: "this is a test"]]]
  end

  test :text_phrase do
    query = query do
      text_phrase "message", "this is a test"
    end

    assert query == [query: [text_phrase: [message: "this is a test"]]]
  end

  test :text_phrase_prefix do
    query = query do
      text_phrase_prefix "message", [query: "this is a test", max_expansions: 10]
    end

    assert query == [query: [text_phrase_prefix: [message: [query: "this is a test", max_expansions: 10]]]]
  end

  test :geo_shape do
    query = query do
      geo_shape do
        location [relation: "contains"] do
          shape [type: "type", coordinates: [[-45.0, 45.0], [45.0, -45.0]]]
        end
      end
    end

    assert query == [query: [geo_shape: [location: [shape: [type: "type", coordinates: [[-45.0,45.0],[45.0,-45.0]]], relation: "contains"]]]]
  end

  test :filtered do
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

    assert query == [query: [filtered: [query: [term: [tag: "wow"]], filter: [range: [age: [from: 10, to: 20]]]]]]
  end

  test :nested do
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
    assert query == [query: [nested: [query: [bool: [must: [[match: ["obj1.name": [query: "blue"]]],[range: ["obj1.count": [gt: 5]]]]]], path: "obj1", _cache: true]]]
  end

  # test :custom_filters_score do
  #   query = query do
  #     custom_filters_score [score_mode: "first"] do
  #       query do
  #         match_all
  #       end
  #       filters do
  #         object [boost: 1] do
  #           filter do
  #             range "age", [from: 0, to: 10]
  #           end
  #         end
  #         object [boost: 2] do
  #           filter do
  #             range "age", [from: 0, to: 10]
  #           end
  #        end
  #       end
  #     end
  #   end
  #
  #
  #   settings = elastic_settings.new([port: 80, uri: "api.tunehog.com/kiosk-rts"])
  #   IO.puts inspect(do_query(settings, "labeled/track", query))
  #   assert query == [query: [custom_filters_score: [query: [match_all: []], filters: [[[filter: [range: [age: [from: 0, to: 10]]], boost: 1]],[[filter: [range: [age: [from: 0, to: 10]]], boost: 2]]], score_mode: "first"]]]
  #
  # end


end
