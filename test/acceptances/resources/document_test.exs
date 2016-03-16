defmodule Acceptances.Resources.DocumentTest do
  use ExUnit.Case

  alias Tirexs.{HTTP, Resources}


  setup do
    HTTP.delete("bear_test") && :ok
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
