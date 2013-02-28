Code.require_file "../../../test_helper.exs", __FILE__

defmodule FilterTest do
  use ExUnit.Case
  import Tirexs
  use Tirexs.Index.Settings

  test :filter_settings do
    index = init_index([name: "bear_test"])

    settings do
      analysis do
        filter "substring", [type: "nGram", min_gram: 2, max_gram: 32]
        filter "snow_en", [type: "snowball", language: "English"]
      end
    end

    assert index[:settings] == [analysis: [filter: [substring: [type: "nGram", min_gram: 2, max_gram: 32], snow_en: [type: "snowball", language: "English"]]], index: []]
  end

end