defmodule Acceptances.HTTPTest do
  use ExUnit.Case

  import Tirexs.HTTP

  @uri_environment Application.get_env(:tirexs, :uri)


  setup do
    delete("bear_test") && :ok
  end


  test "tries to get some head for resource" do
    { :error, 404, _ } = head("unknown", @uri_environment)
    { :error, 404, _ } = head("unknown")
  end

  test "tries! to get some head for resource" do
    assert_raise(RuntimeError, fn -> head!("unknown") end)
  end

  test "gets some head for particular resource" do
    { :ok, 200, _ } = put("bear_test")
    { :ok, 200, _ } = head("bear_test", @uri_environment)
    { :ok, 200, _ } = head("bear_test")
    { :ok, 200, _ } = head!("bear_test")
  end

  test "gets! some head for particular resource" do
    { :ok, 200, _ } = put("bear_test")
    head!("bear_test")
  end

  test "tries to get some resources" do
    {:error, 404, _ }  = get("missing_index", @uri_environment)
    {:error, 404, _ }  = get("missing_index")
  end

  test "tries! to get some resources" do
    assert_raise(RuntimeError, fn -> get!("missing_index") end)
  end

  test "gets some resources" do
    {:ok, 200, _ }  = get("", @uri_environment)
    {:ok, 200, _ }  = get("")
  end

  test "gets some resources with params" do
    { :ok, 201, _ } = put("/bear_test/my_type/1", [user: "kimchy", id: 1])
    { :ok, 200, %{_source: source} }  = get("/bear_test/my_type/1?_source=unknown")
    assert Map.size(source) == 0
  end

  test "gets some resources with params as list" do
    { :ok, 201, _ } = put("/bear_test/my_type/1", [user: "kimchy", id: 1])
    { :ok, 200, %{_source: source} }  = get("/bear_test/my_type/1", [_source: "unknown"])
    assert Map.size(source) == 0
  end

  test "gets some resources with params as map" do
    { :ok, 201, _ } = put("/bear_test/my_type/1", [user: "kimchy", id: 1])
    { :ok, 200, %{_source: source} }  = get("/bear_test/my_type/1", %{_source: "unknown"})
    assert Map.size(source) == 0
  end

  test "deletes resource" do
    { :ok, 200, _ } = put("/bear_test")
    { :ok, 200, _ } = delete("/bear_test")
  end

  test "tries! delete resource" do
    assert_raise(RuntimeError, fn -> delete!("/unknown") end)
  end

  test "puts and posts some resources" do
    { :ok, 200, _ } = put("/bear_test")
    { :ok, 200, _ } = post("/bear_test/_refresh")
  end

  test "puts! and posts! some resources" do
    put!("/bear_test")
    post!("/bear_test/_refresh")
  end

  test "tries puts! and posts! some resources" do
    assert_raise(RuntimeError, fn -> post!("/bear_test/_refresh") end)
  end

  test "puts and posts empty resource as list" do
    { :ok, 200, _ } = put("/bear_test", [])
    { :ok, 200, _ } = post("/bear_test/_refresh", [])
  end

  test "puts and posts empty resource as map" do
    { :ok, 200, _ } = put("/bear_test", %{})
    { :ok, 200, _ } = post("/bear_test/_refresh", %{})
  end

  test "puts some resource with body as list" do
    { :ok, 201, _ } = put("/bear_test/my_type/1", [user: "kimchy", id: 1])
  end

  test "puts some resource with body as map" do
    { :ok, 201, _ } = put("/bear_test/my_type/1", %{user: "kimchy", id: 1})
  end

  test "posts some resource with body as list" do
    { :ok, 201, _ } = post("/bear_test/my_type", [user: "kimchy"])
  end

  test "posts some resource with body as map" do
    { :ok, 201, _ } = post("/bear_test/my_type", %{user: "kimchy"})
  end
end
