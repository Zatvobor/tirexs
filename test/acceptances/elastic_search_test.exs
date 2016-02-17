Code.require_file "../../test_helper.exs", __ENV__.file

defmodule Acceptances.ElasticSearchTest do

  use ExUnit.Case
  use Tirexs.Mapping, only: :macros
  import Tirexs.Bulk
  import Tirexs.ElasticSearch
  require Tirexs.ElasticSearch
  require Tirexs.Query
  import Tirexs.Search


  @tag skip: "facets were deprecated and removed in 2.0 core"
  test :create_mapping_search do
    settings = Tirexs.ElasticSearch.config()

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

    Tirexs.Manage.refresh("articles", settings)

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

      sort do
        [
          [title: "desc"]
        ]
      end
    end

    result = Tirexs.Query.create_resource(s, settings)

    assert Tirexs.Query.result(result, :count) == 1
    assert List.first(Tirexs.Query.result(result, :hits))[:_source][:id] == 2
  end
end
