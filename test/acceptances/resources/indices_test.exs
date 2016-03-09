defmodule Acceptances.Resources.IndicesTest do
  use ExUnit.Case

  alias Tirexs.{HTTP, Resources}


  setup do
    HTTP.delete("bear_test") && :ok
  end


  test "_refresh/1" do
    { :ok, 200, _ } = HTTP.put("bear_test")
    { :ok, 200, _ } = Resources.bump._refresh("bear_test")
  end

  test "tries _refresh/1" do
    { :error, 404, _ } = Resources.bump._refresh("unknown")
  end

  test "tries _refresh!/1" do
    assert_raise(RuntimeError, fn -> Resources.bump!._refresh("unknown") end)
  end

  test "_flush/1" do
    { :ok, 200, _ } = HTTP.put("bear_test")
    { :ok, 200, _ } = Resources.bump._flush("bear_test")
  end

  test "tries _flush/1" do
    { :error, 404, _ } = Resources.bump._flush("unknown")
  end

  test "tries _flush!/1" do
    assert_raise(RuntimeError, fn -> Resources.bump!._flush("unknown") end)
  end
end
