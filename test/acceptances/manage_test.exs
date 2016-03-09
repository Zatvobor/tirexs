Code.require_file "../../test_helper.exs", __ENV__.file

defmodule Acceptances.ManageTest do
  use ExUnit.Case
  import TestHelpers

  import Tirexs.Bulk

  import Tirexs.Query
  import Tirexs.Mapping, only: :macros
  import Tirexs.Manage.Aliases, only: [aliases: 1, add: 1, remove: 1]
  require Tirexs.ElasticSearch

  @settings Tirexs.ElasticSearch.config()

  setup do
    create_index("bear_test", @settings)

    on_exit fn ->
      remove_index("bear_test", @settings)
      :ok
    end

    :ok
  end


  @tag skip: "deprecated and removed in 2.0 core"
  test :delete_by_query do
    index = [index: "bear_test", type: "bear_type"]
    mappings do
      index "id", type: "integer"
      index "name", type: "string"
    end

    {:ok, _, _} = Tirexs.Mapping.create_resource(index, @settings)

    Tirexs.Bulk.store [index: "bear_test", refresh: true], @settings do
      create id: 1, name: "bar1", description: "foo bar test"
      create id: 2, name: "bar2", description: "foo bar test"
    end

    {:ok, _, body} = Tirexs.ElasticSearch.get("bear_test/_count", @settings)

    assert Dict.get(body, :count) == 2

    query = query do: term "id", 1

    {:ok, _, _} = Tirexs.Manage.delete_by_query([index: "bear_test", q: "id:1"] ++ query, @settings)
    {:ok, _, body} = Tirexs.ElasticSearch.get("bear_test/_count", @settings)

    assert Dict.get(body, :count) == 1
  end

  @tag skip: "deprecated in 1.6.0 and removed in 2.0"
  test :more_like_this do
    Tirexs.Bulk.store [index: "bear_test", refresh: false], @settings do
      create id: 1, name: "bar1", description: "foo bar test", type: "my_type"
      create id: 2, name: "bar2", description: "foo bar test", type: "my_type"
    end

    Tirexs.Manage.refresh(["bear_test"], @settings)

    {:ok, _, body} = Tirexs.Manage.more_like_this([id: 1, type: "my_type", index: "bear_test", mlt_fields: "name,description", min_term_freq: 1], @settings)
    assert Dict.get(body, :hits) |> Dict.get(:hits) == []
  end

  test :update do
    Tirexs.ElasticSearch.put("bear_test/my_type", @settings)
    doc = [user: "kimchy", counter: 1, post_date: "2009-11-15T14:12:12", message: "trying out Elastic Search", id: 1]

    Tirexs.ElasticSearch.put("bear_test/my_type/1", JSX.encode!(doc), @settings)

    update = [doc: [name: "new_name"]]
    Tirexs.Manage.update([index: "bear_test", type: "my_type", id: "1"], update, @settings)
    {_, _, body} = Tirexs.ElasticSearch.get("bear_test/my_type/1", @settings)

    assert body[:_source][:name] == "new_name"
  end
end
