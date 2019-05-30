#
# Run this example from console manually:
#
#   $ mix run -r examples/settings.exs
#   # => curl -X PUT -d '{"settings": {"index": {"blocks": {"write": true},"translog": {"disable_flush": false},"cache": {"filter": {"max_size": -1}},"number_of_replicas": 3},"analysis": {"tokenizer": {"dot-tokenizer": {"type": "path_hierarchy","delimiter": "."}},"filter": {"substring": {"type": "nGram","min_gram": 2,"max_gram": 32}},"analyzer": {"msg_search_analyzer": {"tokenizer": "keyword","filter": ["lowercase"]},"msg_index_analyzer": {"tokenizer": "keyword","filter": ["lowercase","substring"]}}}}}' http://127.0.0.1:9200/bear_test
#
# Run this example from Elixir environment (`iex -S mix`):
#
#   iex> Path.expand("examples/settings.exs") |> Tirexs.load_file
#
Tirexs.DSL.define([index: "bear_test"], fn(index) ->
  import Tirexs.Index.Settings

  settings do
    analysis do
      analyzer "msg_search_analyzer", [tokenizer: "keyword", filter: ["lowercase"]]
      analyzer "msg_index_analyzer", [tokenizer: "keyword", filter: ["lowercase", "substring"]]
      filter "substring", [type: "nGram", min_gram: 2, max_gram: 32]
      tokenizer "dot-tokenizer", [type: "path_hierarchy", delimiter: "."]
    end
  end

  # Below a couple of code lines which could be useful for debugging and getting actual JSON string

  # url  = Tirexs.HTTP.url(index[:index])
  # json = JSX.prettify!(JSX.encode!(Tirexs.ElasticSearch.Settings.to_resource_json(index)))
  # IO.puts "\n# => curl -X PUT -d '#{json}' #{url}"

index end)
