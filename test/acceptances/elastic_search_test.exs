Code.require_file "../../test_helper.exs", __FILE__

defmodule Acceptances.ElasticSearchTest do

  use ExUnit.Case
  import :macros, Tirexs.Mapping
  import Tirexs.Bulk
  import Tirexs.ElasticSearch
  import Tirexs.Search


  test :get_elastic_search_server do
    settings = Tirexs.ElasticSearch.Config.new()
    [status, _, _] = get("missing_index", settings)

    assert status == :error

    [_, _, body] = get("", settings)

    assert body["tagline"] == "You Know, for Search"

  end

  test :create_index do
    settings = Tirexs.ElasticSearch.Config.new()
    delete("bear_test", settings)
    [_, _, body] = put("bear_test", settings)
    assert body["acknowledged"] == true
    delete("bear_test", settings)
  end

  test :delete_index do
    settings = Tirexs.ElasticSearch.Config.new()
    put("bear_test", settings)
    [_, _, body] = delete("bear_test", settings)
    assert body["acknowledged"] == true
  end


  test :head do
    settings = Tirexs.ElasticSearch.Config.new()
    assert exist?("bear_test", settings) == false
    put("bear_test", settings)
    assert exist?("bear_test", settings) == true
    delete("bear_test", settings)
  end

  test :create_type_mapping do
    settings = Tirexs.ElasticSearch.Config.new()
    index = [index: "bear_test", type: "bear_type"]
      mappings do
        indexes "mn_opts_", [type: "object"] do
          indexes "uk", [type: "object"] do
            indexes "credentials", [type: "object"] do
              indexes "available_from", type: "long"
              indexes "buy", type: "object"
              indexes "dld", type: "object"
              indexes "str", type: "object"
              indexes "t2p", type: "object"
              indexes "sby", type: "object"
              indexes "spl", type: "object"
              indexes "spd", type: "object"
              indexes "pre", type: "object"
              indexes "fst", type: "object"
            end
          end
        end
        indexes "rev_history_", type: "object"
      end

    [_, _, body] = Tirexs.Mapping.create_resource(index, settings)

    assert body["acknowledged"] == true

    delete("bear_test", settings)
  end

  test :create_mapping_search do
    settings = Tirexs.ElasticSearch.Config.new()

    delete("articles", settings)

    index = [index: "articles", type: "article"]
    mappings do
      indexes "id", type: "string", index: "not_analyzed", include_in_all: false
      indexes "title", type: "string", boost: 2.0, analyzer: "snowball"
      indexes "tags",  type: "string", analyzer: "keyword"
      indexes "content", type: "string", analyzer: "snowball"
      indexes "authors", [type: "object"] do
        indexes "name", type: "string"
        indexes "nick_name", type: "string"
      end
    end

    Tirexs.Mapping.create_resource(index, settings)

    Tirexs.Bulk.store [index: "articles", refresh: true], settings do
      create id: 1, title: "One", tags: ["elixir"], type: "article"
      create id: 2, title: "Two", tags: ["elixir", "ruby"], type: "article"
      create id: 3, title: "Three", tags: ["java"], type: "article"
      create id: 4, title: "Four", tags: ["erlang"], type: "article"
    end

    :timer.sleep(2_000)

    s = search [index: "articles"] do
      query do
        query_string "title:T*"
      end

      filter do
        terms "tags", ["elixir", "ruby"]
      end

      facets do
        global_tags [global: true] do
          terms field: "tags"
        end

        current_tags do
          terms field: "tags"
        end
      end
    end

    [_, _, result] = Tirexs.Query.create_resource(s, settings)

    assert result["hits"]["total"] == 1

  end

end