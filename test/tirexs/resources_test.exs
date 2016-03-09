defmodule Tirexs.ResourcesTest do
  use ExUnit.Case

  import Tirexs.Resources


  test "urn/1" do
    actual = urn("/_refresh")
    assert actual == "_refresh"
  end

  test "urn/1 with params as string" do
    actual = urn("_upgrade?wait_for_completion=true")
    assert actual == "_upgrade?wait_for_completion=true"
  end

  test "urn/2 with params as list" do
    actual = urn("/_upgrade", { [wait_for_completion: true] })
    assert actual == "_upgrade?wait_for_completion=true"
  end

  test "urn/2 with params as map" do
    actual = urn("/_upgrade", { %{wait_for_completion: true} })
    assert actual == "_upgrade?wait_for_completion=true"
  end

  test "urn/2 as string" do
    actual = urn("bear_test", "/_refresh")
    assert actual == "bear_test/_refresh"
  end

  test "urn/2 as string with params as string" do
    actual = urn("bear_test", "/_refresh?ignore_unavailable=true")
    assert actual == "bear_test/_refresh?ignore_unavailable=true"
  end

  test "urn/3 as string with params as list" do
    actual = urn("bear_test", "/_refresh", { [ignore_unavailable: true] })
    assert actual == "bear_test/_refresh?ignore_unavailable=true"
  end

  test "urn/3 as string with params as map" do
    actual = urn("bear_test", "/_refresh", { %{ignore_unavailable: true} })
    assert actual == "bear_test/_refresh?ignore_unavailable=true"
  end

  test "urn/2 as list" do
    actual = urn(["bear_test", "another_bear_test"], "/_refresh")
    assert actual == "bear_test,another_bear_test/_refresh"
  end

  test "urn/3 as list with params as list" do
    actual = urn(["bear_test", "another_bear_test"], "/_refresh", { [ignore_unavailable: true] })
    assert actual == "bear_test,another_bear_test/_refresh?ignore_unavailable=true"
  end

  test "urn/3 as list with params as map" do
    actual = urn(["bear_test", "another_bear_test"], "/_refresh", { %{ignore_unavailable: true} })
    assert actual == "bear_test,another_bear_test/_refresh?ignore_unavailable=true"
  end

  test "urn/3 as string and name part as string" do
    actual = urn("bear_test", "/_alias", "2015")
    assert actual == "bear_test/_alias/2015"
  end

  test "urn/3 as string and name part as string with params as list" do
    actual = urn("bear_test", "/_alias", "2015", { [local: true] })
    assert actual == "bear_test/_alias/2015?local=true"
  end

  test "urn/3 as string and name part as string with params as map" do
    actual = urn("bear_test", "/_alias", "2015", { %{local: true} })
    assert actual == "bear_test/_alias/2015?local=true"
  end

  test "urn/3 as string and name part as a list" do
    actual = urn("bear_test", "/_alias", ["2015", "2016"])
    assert actual == "bear_test/_alias/2015,2016"
  end

  test "urn/3 as string and name part as a list with params list" do
    actual = urn("bear_test", "/_alias", ["2015", "2016"], { [local: true] })
    assert actual == "bear_test/_alias/2015,2016?local=true"
  end

  test "urn/3 as string and name part as a list with params map" do
    actual = urn("bear_test", "/_alias", ["2015", "2016"], { %{local: true} })
    assert actual == "bear_test/_alias/2015,2016?local=true"
  end

  test "urn/3 as list and string" do
    actual = urn(["bear_test", "another_bear_test"], "/_alias", "2015")
    assert actual == "bear_test,another_bear_test/_alias/2015"
  end

  test "urn/3 as list and name part as string with params as list" do
    actual = urn(["bear_test", "another_bear_test"], "/_alias", "2015", { [local: true] })
    assert actual == "bear_test,another_bear_test/_alias/2015?local=true"
  end

  test "urn/3 as list and name part as string with params as map" do
    actual = urn(["bear_test", "another_bear_test"], "/_alias", "2015", { %{local: true} })
    assert actual == "bear_test,another_bear_test/_alias/2015?local=true"
  end

  test "urn/3 as list and list" do
    actual = urn(["bear_test", "another_bear_test"], "/_alias", ["2015", "2016"])
    assert actual == "bear_test,another_bear_test/_alias/2015,2016"
  end

  test "urn/3 as list and name part as list with params as list" do
    actual = urn(["bear_test", "another_bear_test"], "/_alias", ["2015", "2016"], { [local: true] })
    assert actual == "bear_test,another_bear_test/_alias/2015,2016?local=true"
  end

  test "urn/3 as list and name part as list with params as map" do
    actual = urn(["bear_test", "another_bear_test"], "/_alias", ["2015", "2016"], { %{local: true} })
    assert actual == "bear_test,another_bear_test/_alias/2015,2016?local=true"
  end

  test ~S| urn("bear_test", "bear_type", "10", "/_explain") | do
    actual = urn("bear_test", "bear_type", "10", "/_explain")
    assert actual == "bear_test/bear_type/10/_explain"
  end

  test ~S| urn("bear_test", "bear_type", "10", "/_explain?analyzer=some") | do
    actual = urn("bear_test", "bear_type", "10", "/_explain?analyzer=some")
    assert actual == "bear_test/bear_type/10/_explain?analyzer=some"
  end

  test ~S| urn("bear_test", "bear_type", "10", "/_explain", { [analyzer: "some"] }) | do
    actual = urn("bear_test", "bear_type", "10", "/_explain", { [analyzer: "some"] })
    assert actual == "bear_test/bear_type/10/_explain?analyzer=some"
  end

  test ~S| urn("bear_test", "bear_type", "10", "/_explain", { %{analyzer: "some"} }) | do
    actual = urn("bear_test", "bear_type", "10", "/_explain", { %{analyzer: "some"} })
    assert actual == "bear_test/bear_type/10/_explain?analyzer=some"
  end
end
