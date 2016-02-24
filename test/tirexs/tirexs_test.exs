defmodule TirexsTest do
  use ExUnit.Case

  @expected Tirexs.ENV.default_uri_env


  test "`uri` environment variable (by default)" do
    actual = Application.get_env(:tirexs, :uri)
    assert actual == @expected
  end

  test "get_uri_env/0 (by default)" do
    actual = Tirexs.get_uri_env()
    assert actual == @expected
  end
end
