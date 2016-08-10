defmodule Tirexs.Index.SettingsTest do
  use ExUnit.Case

  import Tirexs.Index.Settings


  test "settings by default" do
    index = [name: "bear_test"]

    settings do
      analysis do
      end

      blocks    []
      translog  []
      cache     []
    end

    expected = [analysis: [], index: [cache: [filter: []], translog: [], blocks: []]]
    assert index[:settings] == expected
  end

  test "settings in general" do
    index = [name: "bear_test"]

    settings do
      analysis do
        analyzer "msg_search_analyzer", [tokenizer: "keyword", filter: ["lowercase"]]
        analyzer "msg_index_analyzer", [tokenizer: "keyword", filter: ["lowercase", "substring"]]
        filter "substring", [type: "nGram", min_gram: 2, max_gram: 32]
        tokenizer "dot-tokenizer", [type: "path_hierarchy", delimiter: "."]
      end

      cache max_size: -1
      translog disable_flush: false
      set number_of_replicas: 3
      blocks write: true
    end

    expected = [analysis: [tokenizer: ["dot-tokenizer": [type: "path_hierarchy", delimiter: "."]], filter: [substring: [type: "nGram", min_gram: 2, max_gram: 32]], analyzer: [msg_search_analyzer: [tokenizer: "keyword", filter: ["lowercase"]], msg_index_analyzer: [tokenizer: "keyword", filter: ["lowercase","substring"]]]], index: [blocks: [write: true], translog: [disable_flush: false], cache: [filter: [max_size: -1]], number_of_replicas: 3]]
    assert index[:settings] == expected
  end
end
