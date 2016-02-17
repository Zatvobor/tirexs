Code.require_file "../../test_helper.exs", __ENV__.file

defmodule Acceptances.BulkTest do
  use ExUnit.Case

  import Tirexs.Bulk


  test "bulk store" do
    uri = Tirexs.get_uri_env()

    Tirexs.ElasticSearch.delete("bear_test", uri)

    Tirexs.Bulk.store [index: "bear_test", refresh: false], uri do
      create id: 1, title: "bar1", description: "foo bar test"
      create id: 2, title: "bar2", description: "foo bar test"
      create id: 3, title: "bar3", description: "foo bar test"
      create id: 4, title: "bar4", description: "foo bar test"
      create id: 5, title: "bar5", description: "foo bar test"
      create id: 6, title: "bar6", description: "foo bar test"
      create id: 7, title: "bar7", description: "foo bar test"
      create id: 8, title: "bar8", description: "foo bar test"
      create id: 9, title: "bar9", description: "foo bar test"
      create id: 10, title: "bar10", description: "foo bar test"
      create id: 11, title: "bar11", description: "foo bar test"
      delete id: 11
      index  id: 90, title: "barww"
    end

    Tirexs.Manage.refresh("bear_test", uri)
    {_, _, body} = Tirexs.ElasticSearch.get("bear_test/_count", uri)
    assert body[:count] == 11
  end

  test "bulk update" do
    uri = Tirexs.get_uri_env()
    Tirexs.ElasticSearch.delete("bear_test", uri)

    Tirexs.Bulk.store [index: "bear_test", refresh: false], uri do
      create id: 1, title: "bar1", description: "foo bar test"
      create id: 2, title: "bar2", description: "foo bar test"
    end

    Tirexs.Bulk.store [index: "bear_test", type: "document", id: 1, retry_on_conflict: 1, refresh: true], uri do
      update doc: [id: 1, title: "[updated] bar1"]
    end

    {_, _, body} = Tirexs.ElasticSearch.get("bear_test/document/1/_source", uri)
    assert body[:title] == "[updated] bar1"
  end
end
