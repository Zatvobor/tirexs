defmodule Acceptances.BulkTest do
  use ExUnit.Case

  import Tirexs.Bulk
  alias Tirexs.{HTTP, Resources}


  setup do
    HTTP.delete("bear_test") && :ok
  end

  test "bulk store" do
    store [index: "bear_test", refresh: true] do
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

    {_, _, body} = HTTP.get("bear_test/_count")
    assert body[:count] == 11
  end

  test "bulk update" do
    store [index: "bear_test"] do
      create id: 1, title: "bar1", description: "foo bar test"
      create id: 2, title: "bar2", description: "foo bar test"
    end

    store [index: "bear_test", type: "document", id: 1, retry_on_conflict: 1, refresh: true] do
      update doc: [id: 1, title: "[updated] bar1"]
    end

    {_, _, body} = HTTP.get("bear_test/document/1/_source")
    assert body[:title] == "[updated] bar1"
  end
end
