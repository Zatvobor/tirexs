Code.require_file "../../test_helper.exs", __FILE__

defmodule Tirexs.ManageTest do
  use ExUnit.Case

  import Tirexs.ElasticSearch
  import Tirexs.Manage

  import Tirexs.Bulk

  use Tirexs.Query
  use Tirexs.Mapping

  @settings Tirexs.ElasticSearch.Config.new()

  test :count do
    put("bear_test", @settings)
    [_, _, body] = Tirexs.Manage.count([index: "bear_test"], @settings)
    assert body["count"] == 0
    delete("bear_test", @settings)
  end

  test :count_with_query do
    query = query do
      term "user", "kim"
    end

    put("bear_test", @settings)
    [_, _, body] = Tirexs.Manage.count([index: "bear_test"] ++ query, @settings)
    assert body["count"] == 0
    delete("bear_test", @settings)
  end

  test :delete_by_query do
    delete("bear_test", @settings)
    index = [name: "bear_test"]
    mappings do
      index "id", type: "integer"
      index "name", type: "string"
    end
    Tirexs.Mapping.create_resource(index, @settings)
    Tirexs.Bulk.store [index: "bear_test", refresh: false], @settings do
      create id: 1, name: "bar1", description: "foo bar test"
      create id: 2, name: "bar2", description: "foo bar test"
    end
    :timer.sleep(2_000)
    [_, _, body] = Tirexs.ElasticSearch.get("bear_test/_count", @settings)

    assert body["count"] == 2

    query = query do
      term "id", 1
    end

    Tirexs.Manage.delete_by_query([index: "bear_test", q: "id:1"] ++ query, @settings)
    [_, _, body] = Tirexs.ElasticSearch.get("bear_test/_count", @settings)
    assert body["count"] == 1

    delete("bear_test", @settings)
    # curl localhost:9200/bear_test/_search -d'{
    #   "query": {
    #     "term":{ "id": 1}
    #   }
    # }'

  end

  test :more_like_this do
    delete("bear_test", @settings)
    Tirexs.Bulk.store [index: "bear_test", refresh: false], @settings do
      create id: 1, name: "bar1", description: "foo bar test", type: "my_type"
      create id: 2, name: "bar2", description: "foo bar test", type: "my_type"
    end
    :timer.sleep(2_000)

    [_, _, body] = Tirexs.Manage.more_like_this([id: 1, type: "my_type", index: "bear_test", mlt_fields: "name,description", min_term_freq: 1], @settings)
    assert body["hits"]["hits"] == []
  end

  test :validate do
    delete("bear_test", @settings)
    put("bear_test/my_type", @settings)
    doc = [user: "kimchy", post_date: "2009-11-15T14:12:12", message: "trying out Elastic Search"]
    put("bear_test/my_type/1", JSON.encode(doc), @settings)

    query = query do
      filtered do
        query do
          query_string "*:*"
        end
        filter do
          term "user", "kimchy"
        end
      end
    end

    [_, _, body] = Tirexs.Manage.validate([index: "bear_test"] ++ query, @settings)

    assert body["valid"] == true

    [_, _, body] = Tirexs.Manage.validate([index: "bear_test", q: "user:foo"], @settings)

    assert body["valid"] == false
    delete("bear_test", @settings)
  end

end