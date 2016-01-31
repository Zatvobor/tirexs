Code.require_file "../../test_helper.exs", __ENV__.file

defmodule Tirexs.AliasesTest do
  use ExUnit.Case

  import Tirexs.Manage.Aliases
  import Tirexs.Query.Filter


  test "remove alias" do
    aliases = aliases do
      remove index: "bear_test", alias: "bear_test_alias"
    end

    assert aliases == [actions: [
      [remove: [
        index: "bear_test", alias: "bear_test_alias"
      ]]
    ]]
  end

  test "add alias" do
    aliases = aliases do
      add index: "bear_test", alias: "bear_test_alias"
    end

    assert aliases == [actions: [
      [add: [
        index: "bear_test", alias: "bear_test_alias"
      ]]
    ]]
  end

  test "alias with filter" do
    filter = filter do
      term "user", "kimchy"
    end

    aliases = aliases do
      add [index: "bear_test", alias: "bear_test_alias"] ++ filter
    end

    assert aliases == [actions: [
      [add: [
        index: "bear_test", alias: "bear_test_alias", filter: [term: [user: "kimchy"]]
      ]]
    ]]
  end
end
