#
# Run this example from console manually:
#
#   $ mix run -r examples/mapping.exs
#   # => curl -X PUT -d '{ "settings": { "analysis": { "filter": { "edge_ngram": { "type": "edgeNGram", "min_gram": 1, "max_gram": 15 } }, "analyzer": { "autocomplete_analyzer": { "filter": [ "lowercase", "asciifolding", "edge_ngram" ], "tokenizer": "whitespace" } } }, "index": [] }, "mappings": { "dsl": { "dynamic": "false", "properties": { "country": { "type": "string" }, "city": { "type": "string" }, "suburb": { "type": "string" }, "road": { "type": "string" }, "postcode": { "type": "string", "index": "not_analyzed" }, "housenumber": { "type": "string", "index": "not_analyzed" }, "coordinates": { "type": "geo_point" }, "full_address": { "type": "string", "analyzer": "autocomplete_analyzer" } } } } }' http://127.0.0.1:9200/bear_test
#
# Run this example from Elixir environment (`iex -S mix`):
#
#   iex> Path.expand("examples/mapping_with_settings.exs") |> Tirexs.load_file
#
Tirexs.DSL.define(fn() ->
  use Tirexs.Mapping

  index = [type: "dsl", index: "bear_test"]

  settings do
    analysis do
      analyzer "autocomplete_analyzer",
      [
        filter: ["lowercase", "asciifolding", "edge_ngram"],
        tokenizer: "whitespace"
      ]
      filter "edge_ngram", [type: "edgeNGram", min_gram: 1, max_gram: 15]
    end
  end

  mappings dynamic: "false" do
    indexes "country", type: "string"
    indexes "city", type: "string"
    indexes "suburb", type: "string"
    indexes "road", type: "string"
    indexes "postcode", type: "string", index: "not_analyzed"
    indexes "housenumber", type: "string", index: "not_analyzed"
    indexes "coordinates", type: "geo_point"
    indexes "full_address", type: "string", analyzer: "autocomplete_analyzer"
  end

  # Below a couple of code lines which could be useful for debugging and getting actual JSON string

  # url  = Tirexs.HTTP.url(index[:index])
  # json = JSX.prettify!(JSX.encode!(Tirexs.Mapping.to_resource_json(index)))
  # IO.puts "\n# => curl -X PUT -d '#{json}' #{url}"

index end)
