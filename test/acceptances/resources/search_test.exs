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

  test "_field_stats/0" do
    { :ok, 200, _ } = HTTP.put("/bear_test")
    { :ok, 200, _ } = Resources.bump([fields: ["rating"]])._field_stats()
  end

  test "_field_stats/2" do
    { :ok, 200, _ } = HTTP.put("/bear_test")
    { :ok, 200, _ } = Resources.bump._field_stats("bear_test", { [fields: "some"] })
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

  test "_count/2" do
    { :ok, 201, _ } = HTTP.put("/bear_test/my_type/2?refresh=true", [user: "zatvobor"])
    search          = [query: [ term: [ user: "zatvobor" ] ]]
    { :ok, 200, r } = Resources.bump(search)._count("bear_test", "my_type")
    assert r[:count] == 1
  end
end
