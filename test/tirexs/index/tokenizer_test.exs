Code.require_file "../../../test_helper.exs", __FILE__

defmodule Tirexs.Index.TokenizerTest do
  use ExUnit.Case
  import Tirexs.Index.Settings

  test :tokenizer_settings do
    index = [name: "bear_test"]

    settings do
      analysis do
        tokenizer "dot-tokenizer", [type: "path_hierarchy", delimiter: "."]
      end
    end

    assert index[:settings] == [analysis: [tokenizer: ["dot-tokenizer": [type: "path_hierarchy", delimiter: "."]]], index: []]
  end

end