defmodule Acceptances.Resources.IndicesTest do
  use ExUnit.Case

  alias Tirexs.{HTTP, Resources}


  setup do
    HTTP.delete("bear_test") && HTTP.put("bear_test") && :ok
  end


  test "_refresh/1" do
    { :ok, 200, _ } = Resources.bump._refresh("bear_test")
  end

  test "tries _refresh/1" do
    { :error, 404, _ } = Resources.bump._refresh("unknown")
  end

  test "tries _refresh!/1" do
    assert_raise(RuntimeError, fn -> Resources.bump!._refresh("unknown") end)
  end

  test "_flush/1" do
    { :ok, 200, _ } = Resources.bump._flush("bear_test")
  end

  test "tries _flush/1" do
    { :error, 404, _ } = Resources.bump._flush("unknown")
  end

  test "tries _flush!/1" do
    assert_raise(RuntimeError, fn -> Resources.bump!._flush("unknown") end)
  end

  test "aliases/0 with request body as macro" do
    import Tirexs.Manage.Aliases, only: [aliases: 1, add: 1, remove: 1]
    query = aliases do
      add index: "bear_test", alias: "bear_test_alias"
    end

    { :ok, 200, _ } = Resources.bump(query)._aliases
    { :ok, 200, r } = HTTP.get("_aliases")
    assert r[:bear_test][:aliases] == %{bear_test_alias: %{}}
  end

  test "aliases/0 with request body as macro (chain)" do
    import Tirexs.Manage.Aliases, only: [aliases: 1, add: 1]
    query = aliases do
      add    index: "bear_test", alias: "bear_test_alias2"
      add    index: "bear_test", alias: "bear_test_alias3"
    end

    { :ok, 200, _ } = Resources.bump(query)._aliases
    { :ok, 200, r } = HTTP.get("_aliases")
    assert r[:bear_test][:aliases] == %{bear_test_alias2: %{}, bear_test_alias3: %{}}
  end
end
