defmodule Acceptances.ScrollTest do
  use ExUnit.Case


  import Tirexs.Search
  import Tirexs.Bulk

  require Tirexs.Query

  alias Tirexs.{HTTP, Query}


  setup do
    HTTP.delete("bear_test") && :ok
  end

  test :scroll do
    Tirexs.Bulk.store [index: "bear_test", refresh: true] do
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

    s = search [index: "bear_test"] do
      query do
        string "bar7"
      end
    end

    settings = Tirexs.get_uri_env()
    body = Query.create_resource(s, settings, [scroll: "5m"])
    assert Query.result(body, :_scroll_id)
  end

end
