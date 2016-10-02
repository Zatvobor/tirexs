defmodule Acceptances.MappingTest do
  use ExUnit.Case

  use Tirexs.Mapping
  alias Tirexs.{HTTP, Resources}


  setup_all do
    HTTP.delete("bear_test") && :ok
  end

  test "mappings definition (basic)" do
    index = [index: "bear_test", type: "bear_type"]
    mappings do
      indexes "mn_opts_", [type: "object"] do
        indexes "uk", [type: "object"] do
          indexes "credentials", [type: "object"] do
            indexes "available_from", type: "long"
            indexes "buy", type: "object"
            indexes "dld", type: "object"
            indexes "str", type: "object"
            indexes "t2p", type: "object"
            indexes "sby", type: "object"
            indexes "spl", type: "object"
            indexes "spd", type: "object"
            indexes "pre", type: "object"
            indexes "fst", type: "object"
          end
        end
      end
      indexes "rev_history_", type: "object"
    end

    {:ok, _, body} = Tirexs.Mapping.create_resource(index)

    assert body[:acknowledged] == true
  end

  test "create mapping and settings" do
    HTTP.delete("articles")

    index = [index: "articles", type: "article"]
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
    mappings dynamic: "false", _parent: [type: "parent"] do
      indexes "country", type: "string"
      indexes "city", type: "string"
      indexes "suburb", type: "string"
      indexes "road", type: "string"
      indexes "postcode", type: "string", index: "not_analyzed"
      indexes "housenumber", type: "string", index: "not_analyzed"
      indexes "coordinates", type: "geo_point"
      indexes "full_address", type: "string", analyzer: "autocomplete_analyzer"
    end

    Tirexs.Mapping.create_resource(index)

    Resources.bump!._refresh("articles")

    {:ok, 200, response} = HTTP.get("articles")

    settings = response[:articles][:settings]
    mappings = response[:articles][:mappings]

    %{index: %{analysis: analyzer}} = settings

    assert %{analyzer: %{autocomplete_analyzer: %{filter: ["lowercase", "asciifolding", "edge_ngram"], tokenizer: "whitespace"}}, filter: %{edge_ngram: %{max_gram: "15", min_gram: "1", type: "edgeNGram"}}} == analyzer

    %{article: properties} = mappings

    assert %{dynamic: "false", _parent: %{type: "parent"}, _routing: %{required: true}, properties: %{city: %{type: "string"}, coordinates: %{type: "geo_point"}, country: %{type: "string"}, full_address: %{analyzer: "autocomplete_analyzer", type: "string"}, housenumber: %{index: "not_analyzed", type: "string"}, postcode: %{index: "not_analyzed", type: "string"}, road: %{type: "string"}, suburb: %{type: "string"}}} == properties
  end
end
