Code.require_file "../../../../test_helper.exs", __ENV__.file

defmodule Tirexs.Index.Settings.CacheTest do
  use ExUnit.Case

  import Tirexs.Index.Settings


  test "settings w/ cache" do
    index = [name: "bear_test"]

    settings do
      cache max_size: -1, expire: -1
    end

    expected = [cache: [filter: [max_size: -1, expire: -1]]]
    assert index[:settings] == expected
  end
end
