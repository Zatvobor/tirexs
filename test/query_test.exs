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

    # settings = elastic_settings.new([port: 80, uri: "api.tunehog.com/kiosk-rts"])
    # do_query(settings, "labeled/track", query)
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
    # settings = elastic_settings.new([port: 80, uri: "api.tunehog.com/kiosk-rts"])
    # IO.puts inspect(do_query(settings, "labeled/track", query))
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


end
