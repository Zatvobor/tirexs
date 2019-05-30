Code.require_file "../../../../test_helper.exs", __ENV__.file

defmodule Tirexs.Index.Settings.FilterTest do
  use ExUnit.Case

  import Tirexs.Index.Settings


  test "settings w/ filter" do
    index = [name: "bear_test"]

    settings do
      analysis do
        filter "substring", [type: "nGram", min_gram: 2, max_gram: 32]
        filter "snow_en", [type: "snowball", language: "English"]
      end
    end

    expected = [analysis: [filter: [substring: [type: "nGram", min_gram: 2, max_gram: 32], snow_en: [type: "snowball", language: "English"]]]]
    assert index[:settings] == expected
  end
end
