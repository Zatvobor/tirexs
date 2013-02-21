Code.require_file "../../test_helper.exs", __FILE__

defmodule AnalyzerTest do
  use ExUnit.Case
  import Tirexs
  use Tirexs.Index.Settings

  test :analyzer_settings do
    index = init_index([name: "bear_test"])

    settings do
      analysis do
        analyzer "msg_search_analyzer", [tokenizer: "keyword", filter: ["lowercase"]]
        analyzer "msg_index_analyzer", [tokenizer: "keyword", filter: ["lowercase", "substring"]]
      end
    end

    assert index[:settings] == [analysis: [analyzer: [msg_search_analyzer: [tokenizer: "keyword", filter: ["lowercase"]], msg_index_analyzer: [tokenizer: "keyword", filter: ["lowercase","substring"]]]], index: []]
  end

end