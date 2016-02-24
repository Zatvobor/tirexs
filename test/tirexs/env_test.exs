defmodule Tirexs.ENVTest do
  use ExUnit.Case

  alias Tirexs.ENV

  @expected ENV.default_uri_env


  setup do
    on_exit fn ->
      :ok = Application.put_env(:tirexs, :uri, @expected)
      :ok = System.delete_env("ES_URI")
    end
  end


  test "get_all_env/0" do
    actual = ENV.get_all_env()
    assert(length(actual) > 0)
  end

  test "get_uri_env/0 (by default)" do
    actual = ENV.get_uri_env()
    assert actual == @expected
  end

  test "get_env(:uri)" do
    actual = ENV.get_env(:uri)
    assert actual == @expected
  end

  test "get_uri_env/0 (that has been set as string)" do
    :ok = Application.put_env(:tirexs, :uri, "http://127.0.0.1:92")
    actual = ENV.get_uri_env()
    assert actual.authority == "127.0.0.1:92"
  end

  test "get_uri_env/0 (that has been set as list)" do
    :ok = Application.put_env(:tirexs, :uri, [ authority: "127.0.0.1:9200", scheme: "http", host: "127.0.0.1", port: 9200 ])
    actual = ENV.get_uri_env()
    assert actual == @expected
  end

  test "get_uri_env/0 (that has been set as unknown format)" do
    :ok = Application.put_env(:tirexs, :uri, true)
    assert_raise(FunctionClauseError, fn -> ENV.get_uri_env() end)
  end

  test "get_uri_env/0 (that has been set as ES_URI variable)" do
    :ok = System.put_env("ES_URI", "http://example.com:9200")
    actual = ENV.get_uri_env()
    assert actual.authority == "example.com:9200"
  end
end
