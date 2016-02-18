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

  test "gets some head for particular resource" do
    { :ok, 200, _ } = put("bear_test")
    { :ok, 200, _ } = head("bear_test", @uri_environment)
    { :ok, 200, _ } = head("bear_test")
  end

  test "tries to get some resources" do
    {:error, 404, _ }  = get("missing_index", @uri_environment)
    {:error, 404, _ }  = get("missing_index")
  end

  test "gets some resources" do
    {:ok, 200, _ }  = get("", @uri_environment)
    {:ok, 200, _ }  = get("")
  end

  test "deletes resource" do
    { :ok, 200, _ } = put("/bear_test")
    { :ok, 200, _ } = delete("/bear_test")
  end

  test "posts and puts some resources" do
    { :ok, 200, _ } = put("/bear_test")
    { :ok, 200, _ } = post("/bear_test/_refresh")
  end

  @tag skip: "pending"
  test "posts some resource with body"

  @tag skip: "pending"
  test "puts some resource with body"
end
