Code.require_file "../../test_helper.exs", __FILE__
defmodule BulkTest do
  use ExUnit.Case
  import Tirexs.Bulk
  import ParserResponse

  test :create do
    settings = Tirexs.ElasticSearch.Config.new()
    Tirexs.ElasticSearch.delete("bear_test", settings)

    Tirexs.Bulk.store [index: "bear_test", refresh: false], settings do
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

    :timer.sleep(2_000)
    body = get_body_json(Tirexs.ElasticSearch.get("bear_test/_count", settings))
    assert body["count"] == 11

    Tirexs.ElasticSearch.delete("bear_test", settings)
  end

end
