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

    index = [index: "articles", type: "_doc"]
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
      indexes "country", type: "text"
      indexes "city", type: "text"
      indexes "suburb", type: "text"
      indexes "road", type: "text"
      indexes "postcode", type: "text"
      indexes "housenumber", type: "text"
      indexes "coordinates", type: "geo_point"
      indexes "full_address", type: "text", analyzer: "autocomplete_analyzer"
    end

    Tirexs.Mapping.create_resource(index)

    Resources.bump!._refresh("articles")

    {:ok, 200, response} = HTTP.get("articles")

    settings = response[:articles][:settings]
    mappings = response[:articles][:mappings]

    %{index: %{analysis: analyzer}} = settings

    assert %{analyzer: %{autocomplete_analyzer: %{filter: ["lowercase", "asciifolding", "edge_ngram"], tokenizer: "whitespace"}}, filter: %{edge_ngram: %{max_gram: "15", min_gram: "1", type: "edgeNGram"}}} == analyzer

    %{_doc: properties} = mappings

    assert %{dynamic: "false", properties: %{city: %{type: "text"}, coordinates: %{type: "geo_point"}, country: %{type: "text"}, full_address: %{analyzer: "autocomplete_analyzer", type: "text"}, housenumber: %{type: "text"}, postcode: %{type: "text"}, road: %{type: "text"}, suburb: %{type: "text"}}} == properties
  end
end
