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

  test "_explain/2" do
    { :ok, 201, _ } = HTTP.put("/bear_test/my_type/2?refresh=true", [user: "zatvobor"])
    { :ok, 200, r } = Resources.bump._explain("bear_test/my_type/2", { [q: "user:z*"] })
    assert r[:matched]
  end
end
