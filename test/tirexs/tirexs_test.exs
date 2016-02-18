defmodule TirexsTest do
  use ExUnit.Case

  @uri_environment Application.get_env(:tirexs, :uri)


  test "`uri` environment variable (by default)" do
    assert @uri_environment == %URI{ scheme: "http", userinfo: nil, host: "127.0.0.1", port: 9200 }
  end

  test "get_all_env/0" do
    actual = Tirexs.get_all_env()
    assert(length(actual) > 0)
  end

  test "get_uri_env/0 (by default)" do
    actual = Tirexs.get_uri_env()
    assert actual == @uri_environment
  end
end
