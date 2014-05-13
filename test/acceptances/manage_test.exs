Code.require_file "../../test_helper.exs", __ENV__.file

defmodule Acceptances.ManageTest do
  use ExUnit.Case
  import TestHelpers

  import Tirexs.Bulk

  import Tirexs.Query
  import Tirexs.Mapping, only: :macros

  @settings Tirexs.ElasticSearch.Config.new()

  setup do
    create_index("bear_test", @settings)
    :ok
  end

  teardown do
    remove_index("bear_test", @settings)
    :ok
  end

  test :count do
    {:ok, 200, body} = repeat fn -> Tirexs.Manage.count([index: "bear_test"], @settings) end
    assert Dict.get(body, :count) == 0
  end

  test :count_with_query do
    query = query do
      term "user", "kim"
    end

    {:ok, 200, body} = repeat fn -> Tirexs.Manage.count([index: "bear_test"] ++ query, @settings) end
    assert Dict.get(body, :count) == 0
  end

  test :delete_by_query do
    index = [index: "bear_test"]
    mappings do
      index "id", type: "integer"
      index "name", type: "string"
    end
    Tirexs.Mapping.create_resource(index, @settings)
    Tirexs.Bulk.store [index: "bear_test", refresh: false], @settings do
      create id: 1, name: "bar1", description: "foo bar test"
      create id: 2, name: "bar2", description: "foo bar test"
    end

    Tirexs.Manage.refresh(["bear_test"], @settings)

    {_, _, body} = Tirexs.ElasticSearch.get("bear_test/_count", @settings)

    assert Dict.get(body, :count) == 2

    query = query do
      term "id", 1
    end

    Tirexs.Manage.delete_by_query([index: "bear_test", q: "id:1"] ++ query, @settings)
    {_, _, body} = Tirexs.ElasticSearch.get("bear_test/_count", @settings)
    assert Dict.get(body, :count) == 1
  end

  test :more_like_this do
    Tirexs.Bulk.store [index: "bear_test", refresh: false], @settings do
      create id: 1, name: "bar1", description: "foo bar test", type: "my_type"
      create id: 2, name: "bar2", description: "foo bar test", type: "my_type"
    end

    Tirexs.Manage.refresh(["bear_test"], @settings)

    {_, _, body} = Tirexs.Manage.more_like_this([id: 1, type: "my_type", index: "bear_test", mlt_fields: "name,description", min_term_freq: 1], @settings)
    assert Dict.get(body, :hits) |> Dict.get(:hits) == []
  end

  test :validate_and_explain do
    doc = [user: "kimchy", post_date: "2009-11-15T14:12:12", message: "trying out Elastic Search"]
    Tirexs.ElasticSearch.put("bear_test/my_type/1", JSEX.encode!(doc), @settings)

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

    {_, _, body} = Tirexs.Manage.validate([index: "bear_test"] ++ query, @settings)
    assert Dict.get(body, :valid) == true

    {_, _, body} = Tirexs.Manage.validate([index: "bear_test", q: "user:foo"], @settings)

    assert Dict.get(body, :valid) == true

    {_, _, body} = Tirexs.Manage.explain([index: "bear_test", type: "my_type", id: 1, q: "message:search"], @settings)
    body = JSEX.decode!(to_string(body), [{:labels, :atom}])
    assert Dict.get(body, :matched) == false
  end

  # test :update do
  #   Tirexs.ElasticSearch.put("bear_test/my_type", @settings)
  #   doc = [user: "kimchy", counter: 1, post_date: "2009-11-15T14:12:12", message: "trying out Elastic Search", id: 1]
  #   Tirexs.ElasticSearch.put("bear_test/my_type/1", JSEX.encode!(doc), @settings)

  #   {_, _, body} = Tirexs.ElasticSearch.get("bear_test/my_type/1", @settings)

  #   assert body[:_source][:counter] == 1
  #   update = [script: "ctx._source.counter += count", params: [count: 1]]
  #   Tirexs.Manage.update([index: "bear_test", type: "my_type", id: "1"], update, @settings)

  #   {_, _, body} = Tirexs.ElasticSearch.get("bear_test/my_type/1", @settings)
  #   assert body[:_source][:counter] == 2

  #   update_doc = [doc: [name: "new_name"]]
  #   Tirexs.Manage.update([index: "bear_test", type: "my_type", id: "1"], update_doc, @settings)
  #   {_, _, body} = Tirexs.ElasticSearch.get("bear_test/my_type/1", @settings)
  #   assert body[:_source][:name] == "new_name"
  # end


end
