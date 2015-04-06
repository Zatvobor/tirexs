#
# Run this example from console manually:
#
#   $ mix run -r examples/settings.exs
#   # => curl -X PUT -d '{"settings": {"index": {"blocks": {"write": true},"translog": {"disable_flush": false},"cache": {"filter": {"max_size": -1}},"number_of_replicas": 3},"analysis": {"tokenizer": {"dot-tokenizer": {"type": "path_hierarchy","delimiter": "."}},"filter": {"substring": {"type": "nGram","min_gram": 2,"max_gram": 32}},"analyzer": {"msg_search_analyzer": {"tokenizer": "keyword","filter": ["lowercase"]},"msg_index_analyzer": {"tokenizer": "keyword","filter": ["lowercase","substring"]}}}}}' http://127.0.0.1:9200/test_dsl_settings
#
# Run this example from Elixir environment (`iex -S mix`):
#
#   iex> Tirexs.Loader.load Path.expand("examples/settings.exs")
#

import Tirexs.Index.Settings

Tirexs.DSL.define [index: "test_dsl_settings"], fn(index, elastic_settings) ->

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

  # Below a couple of code lines which could be useful for debugging and getting actual JSON string
  # url  = Tirexs.ElasticSearch.make_url(index[:index], elastic_settings)
  # json = JSX.prettify!(Tirexs.ElasticSearch.Settings.to_resource_json(index))
  # IO.puts "\n# => curl -X PUT -d '#{json}' #{url}"

  { index, elastic_settings }
end
