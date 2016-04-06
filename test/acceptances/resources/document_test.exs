defmodule Acceptances.Resources.DocumentTest do
  use ExUnit.Case

  alias Tirexs.{HTTP, Resources}


  setup do
    HTTP.delete("bear_test") && :ok
  end

  test "_mget/0 w/ raw request body" do
    { :ok, 201, _ } = HTTP.put("/bear_test/my_type/1?refresh=true", [user: "kimchy"])
    request = ~S'''
    {"docs" : [{"_index":"bear_test", "_type":"my_type", "_id":"1"}]}
    '''
    { :ok, 200, %{docs: [%{found: found}]} } = Resources.bump(request)._mget()
    assert found
  end

  test "_mget/1 w/ raw request body" do
    { :ok, 201, _ } = HTTP.put("/bear_test/my_type/1?refresh=true", [user: "kimchy"])
    request = ~S'''
    {"docs" : [{"_type":"my_type", "_id":"1"}]}
    '''
    { :ok, 200, %{docs: [%{found: found}]} } = Resources.bump(request)._mget("bear_test")
    assert found
  end

  test "_mget/2 w/ raw request body" do
    { :ok, 201, _ } = HTTP.put("/bear_test/my_type/1?refresh=true", [user: "kimchy"])
    request = ~S'''
    {"docs" : [{"_id":"1"}]}
    '''
    { :ok, 200, %{docs: [%{found: found}]} } = Resources.bump(request)._mget("bear_test", "my_type")
    assert found
  end

  test "_update" do
    HTTP.put!("/bear_test/my_type/1?refresh=true", [user: "kimchy"])
    Resources.bump!([doc: [user: "zatvobor"]])._update("/bear_test/my_type/1")
    { :ok, 200, %{_source: %{user: user}} } = Resources.bump.doc("/bear_test/my_type/1")
    assert user == "zatvobor"
  end

  test "_bulk/0 and payload as a string" do
    payload = ~S'''
    { "index": { "_index": "website", "_type": "blog", "_id": "1" }}
    { "title": "My second blog post" }
    '''
    # { :ok, 200, r } = HTTP.post("/_bulk", actions)
    # { :ok, 200, r } = Resources.bump(payload)._bulk({ [refresh: true] })
    { :ok, 200, r } = Resources.bump(payload)._bulk()
    refute r[:errors]
  end

  test "_bulk/2 and payload as a string" do
    payload = ~S'''
    { "index": { "_id": "2" }}
    { "title": "My second blog post" }
    '''
    # { :ok, 200, r } = Resources.bump(payload)._bulk("website", "blog", { [refresh: true] })
    { :ok, 200, r } = Resources.bump(payload)._bulk("website", "blog")
    refute r[:errors]
  end

  import Tirexs.Bulk

  test "_bulk/1 w/ default in the URL and payload macro" do
    payload = bulk do
      index [
        [id: 1, title: "My second blog post"]
        # ...
      ]
    end
    # { :ok, 200, r } = Resources.bump(payload)._bulk("website/blog", { [refresh: true] })
    { :ok, 200, r } = Resources.bump(payload)._bulk("website/blog")
    refute r[:errors]
  end

  test "_bulk/0 w/ default in the URL and payload macro" do
    payload = bulk([ index: "website", type: "blog" ]) do
      index [
        [id: 1, title: "My second blog post"]
        # ...
      ]
    end
    { :ok, 200, r } = Resources.bump(payload)._bulk()
    refute r[:errors]
  end

  test "_bulk/0 and payload macro" do
    payload = bulk do
      index [ index: "website", type: "blog" ], [
        [id: 1, title: "My second blog post"]
        # ...
      ]
    end
    { :ok, 200, r } = Resources.bump(payload)._bulk()
    refute r[:errors]
  end

  test "bulk/2 macro w/ default in the URL" do
    payload = bulk([]) do
      index [
        [id: 1, title: "My second blog post"]
        # ...
      ]
    end
    { :ok, 200, r } = Resources.bump(payload)._bulk("website", "blog")
    refute r[:errors]
  end
end
