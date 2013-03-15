Code.require_file "../../../test_helper.exs", __FILE__

defmodule Tirexs.Index.CacheTest do
  use ExUnit.Case
  import Tirexs.Index.Settings

  test :cache_settings do
    index = [name: "bear_test"]

    settings do
      cache max_size: -1,
            expire: -1
    end

    assert index[:settings] == [index: [cache: [filter: [max_size: -1, expire: -1]]]]
  end

end