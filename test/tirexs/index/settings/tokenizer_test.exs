Code.require_file "../../../../test_helper.exs", __ENV__.file

defmodule Tirexs.Index.Settings.TokenizerTest do
  use ExUnit.Case

  import Tirexs.Index.Settings


  test "settings w/ tokenizer" do
    index = [name: "bear_test"]

    settings do
      analysis do
        tokenizer "dot-tokenizer", [type: "path_hierarchy", delimiter: "."]
      end
    end

    expected = [analysis: [tokenizer: ["dot-tokenizer": [type: "path_hierarchy", delimiter: "."]]]]
    assert index[:settings] == expected
  end
end
