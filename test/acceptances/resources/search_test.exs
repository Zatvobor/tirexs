defmodule Acceptances.Resources.SearchTest do
  use ExUnit.Case

  alias Tirexs.{HTTP, Resources}


  setup do
    HTTP.delete("bear_test") && :ok
  end


  test "_explain/4" do
    { :ok, 201, _ } = HTTP.put("/bear_test/my_type/1?refresh=true", [user: "kimchy"])
    { :ok, 200, r } = Resources.bump._explain("bear_test", "my_type", "1", { [q: "user:k*"] })
    assert r[:matched]
  end

  test "_explain/3" do
    { :ok, 201, _ } = HTTP.put("/bear_test/my_type/1?refresh=true", [user: "kimchy"])
    search          = [query: [ term: [ user: "kimchy" ] ]]
    { :ok, 200, r } = Resources.bump(search)._explain("bear_test", "my_type", "1")
    assert r[:matched]
  end

  test "_explain/2" do
    { :ok, 201, _ } = HTTP.put("/bear_test/my_type/2?refresh=true", [user: "zatvobor"])
    { :ok, 200, r } = Resources.bump._explain("bear_test/my_type/2", { [q: "user:z*"] })
    assert r[:matched]
  end

  test "_explain/1" do
    { :ok, 201, _ } = HTTP.put("/bear_test/my_type/2?refresh=true", [user: "zatvobor"])
    search          = [query: [ term: [ user: "zatvobor" ] ]]
    { :ok, 200, r } = Resources.bump(search)._explain("bear_test/my_type/2")
    assert r[:matched]
  end

  test "_search_shards/2" do
    { :ok, 200, _ } = HTTP.put("/bear_test")
    { :ok, 200, _ } = Resources.bump._search_shards("bear_test", { [local: true] })
  end

  test "_validate_query/2" do
    { :ok, 201, _ } = HTTP.put("/bear_test/my_type/1?refresh=true", [user: "kimchy"])
    { :ok, 200, r } = Resources.bump._validate_query("bear_test", { [q: "user1:z*"] })
    assert r[:valid]
  end

  test "_validate_query/1" do
    { :ok, 201, _ } = HTTP.put("/bear_test/my_type/2?refresh=true", [user: "zatvobor"])
    search          = [query: [ term: [ user: "zatvobor" ] ]]
    { :ok, 200, r } = Resources.bump(search)._validate_query("bear_test")
    assert r[:valid]
  end

  test "_validate_query/0 with request body as macro" do
    { :ok, 201, _ } = HTTP.put("/bear_test/my_type/2?refresh=true", [user: "zatvobor", message: "trying out Elastic Search"])

    import Tirexs.Query, only: :macros
    query = query do
      bool do
        must do
          term "user", "kimchy"
        end
      end
    end
    { :ok, 200, r } = Resources.bump(query)._validate_query("bear_test")
    assert r[:valid]
  end

  test "_count/2" do
    { :ok, 201, _ } = HTTP.put("/bear_test/my_type/2?refresh=true", [user: "zatvobor"])
    search          = [query: [ term: [ user: "zatvobor" ] ]]
    { :ok, 200, r } = Resources.bump(search)._count("bear_test", "my_type")
    assert r[:count] == 1
  end

  test "_search/2" do
    { :ok, 201, _ } = HTTP.put("/bear_test/my_type/2?refresh=true", [user: "zatvobor"])
    search          = [query: [ term: [ user: "zatvobor" ] ]]
    { :ok, 200, r } = Resources.bump(search)._search("bear_test", "my_type")
    assert r[:hits][:total] == 1
  end

  test "_search/2 with macro" do
    import Tirexs.Search
    { :ok, 201, _ } = HTTP.put("/bear_test/my_type/2?refresh=true", [user: "zatvobor"])
    request = search do
      query do
        term "user", "zatvobor"
      end
    end
    { :ok, 200, r } = Resources.bump(request[:search])._search("bear_test", "my_type")
    assert r[:hits][:total] == 1
  end

  test "_search_scroll/0" do
    import Tirexs.Bulk
    import Tirexs.Search

    payload = bulk([index: "bear_test", type: "bear_type"]) do
      create [
        [ id: 1, title: "bar1", description: "foo bar test" ],
        [ id: 2, title: "bar2", description: "foo bar test" ],
        [ id: 3, title: "bar3", description: "foo bar test" ],
        [ id: 4, title: "bar4", description: "foo bar test" ],
        [ id: 5, title: "bar5", description: "foo bar test" ],
        [ id: 6, title: "bar6", description: "foo bar test" ],
        [ id: 7, title: "bar7", description: "foo bar test" ],
        [ id: 8, title: "bar8", description: "foo bar test" ],
        [ id: 9, title: "bar9", description: "foo bar test" ],
        [ id: 10, title: "bar10", description: "foo bar test" ],
        [ id: 11, title: "bar11", description: "foo bar test" ]
      ]
      delete([ [ id: 11 ] ])
      index([ [ id: 90, title: "barww" ] ])
    end
    Tirexs.bump!(payload)._bulk({[refresh: true]})

    request = search([index: "bear_test"]) do
      query do
        string "bar7"
      end
    end

    # { :ok, 200, r } = Query.create_resource(request, [scroll: "5m"])
    { :ok, 200, r } = Tirexs.bump(request[:search])._search("bear_test", {[scroll: "5m"]})
    assert r[:_scroll_id]

    # { :ok, 200, r } = Tirexs.bump([scroll_id: r[:_scroll_id]])._search_scroll()
    { :ok, 200, r } = Tirexs.bump._search_scroll(r[:_scroll_id])
    assert r[:hits][:total] == 1

    Tirexs.bump!._search_scroll_all()
  end
end
