Code.require_file "../../test_helper.exs", __FILE__
defmodule ManageTest do
  use ExUnit.Case
  import Tirexs.Manage
  use Tirexs.Filter


  test :singl_alias do
    aliases = Tirexs.Manage.aliases do
      add index: "bear_test", alias: "my_alias1"
    end

    assert aliases == [actions: [[add: [index: "bear_test", alias: "my_alias1"]]]]
  end

  test :alias_with_filter do

    filter = filter do
      term "user", "kimchy"
    end

    aliases = Tirexs.Manage.aliases do
      add index: "bear_test", alias: "my_alias1"
      add [index: "bear_test", alias: "my_alias2"] ++ filter
      remove index: "bear_test", alias: "my_alias1"
    end

    assert aliases == [actions: [[add: [index: "bear_test", alias: "my_alias1"]],[add: [index: "bear_test", alias: "my_alias2", filter: [term: [user: "kimchy"]]]],[remove: [index: "bear_test", alias: "my_alias1"]]]]

    #create aliases
    # settings = Tirexs.ElasticSearch.Config.new()
    # Tirexs.ElasticSearch.post("_aliases", JSON.encode(aliases), settings)
  end
end