Code.require_file "../../test_helper.exs", __FILE__

defmodule Tirexs.ManageTest do
  use ExUnit.Case

  import Tirexs.ElasticSearch
  import Tirexs.Manage

  use Tirexs.Query

  @settings Tirexs.ElasticSearch.Config.new()

  test :count do
    put("bear_test", @settings)
    [_, _, body] = Tirexs.Manage.count([index: "bear_test"], @settings)
    assert body["count"] == 0
    delete("bear_test", @settings)
  end

  test :count_with_query do
    query = query do
      term "user", "kim"
    end

    put("bear_test", @settings)
    [_, _, body] = Tirexs.Manage.count([index: "bear_test"] ++ query, @settings)
    assert body["count"] == 0
    delete("bear_test", @settings)
  end
end