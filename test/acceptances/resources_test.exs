defmodule Acceptances.ResourcesTest do
  use ExUnit.Case

  alias Tirexs.{HTTP, Resources}


  setup do
    HTTP.delete("bear_test") && :ok
  end


  test "exists?/1" do
    { :ok, 200, _ } = HTTP.put("bear_test")
    assert Resources.exists?("bear_test")
  end

  test "tries exists?/1" do
    refute Resources.exists?("unknown")
  end

  test "exists!/1" do
    { :ok, 200, _ } = HTTP.put("bear_test")
    assert Resources.exists!("bear_test")
  end

  test "tries exists!/1" do
    assert_raise(RuntimeError, fn -> Resources.exists!("unknown") end)
  end
end
