import Tirexs.Index.Settings

Tirexs.DSL.define [index: "test_dsl_setting"], fn(index, elastic_settings) ->

  settings do
    analysis do
      analyzer "msg_search_analyzer", [tokenizer: "keyword", filter: ["lowercase"]]
      analyzer "msg_index_analyzer", [tokenizer: "keyword", filter: ["lowercase", "substring"]]
      filter "substring", [type: "nGram", min_gram: 2, max_gram: 32]
      tokenizer "dot-tokenizer", [type: "path_hierarchy", delimiter: "."]
    end

    cache    max_size: -1
    translog disable_flush: false
    set      number_of_replicas: 3
    blocks   write: true
  end

  { index, elastic_settings }
end