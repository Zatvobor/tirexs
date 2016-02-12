Code.require_file "../../../../test_helper.exs", __ENV__.file

defmodule Tirexs.Index.Settings.AnalyzerTest do
  use ExUnit.Case

  import Tirexs.Index.Settings


  test "settings w/ analysis" do
    index = [name: "bear_test"]

    settings do
      analysis do
        analyzer "msg_search_analyzer", [tokenizer: "keyword", filter: ["lowercase"]]
        analyzer "msg_index_analyzer", [tokenizer: "keyword", filter: ["lowercase", "substring"]]
      end
    end

    expected = [analysis: [analyzer: [msg_search_analyzer: [tokenizer: "keyword", filter: ["lowercase"]], msg_index_analyzer: [tokenizer: "keyword", filter: ["lowercase","substring"]]]], index: []]
    assert index[:settings] == expected
  end
end
