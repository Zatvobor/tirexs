defmodule Acceptances.SettingsTest do
  use ExUnit.Case

  import Tirexs.Index.Settings
  alias Tirexs.{HTTP}

  setup_all do
    HTTP.delete("bear_test") && :ok
  end

  test "create settings" do
    index_name = "bear_test"
    index = [index: index_name]
    settings do
      analysis do
        analyzer "autocomplete_analyzer",
        [
          filter: ["lowercase", "asciifolding"],
          tokenizer: "whitespace"
        ]
      end
    end

    {:ok, _, body} = Tirexs.ElasticSearch.Settings.create_resource(index)
    assert body[:acknowledged] == true

    {:ok, _, body} = Tirexs.bump()._settings(index_name)
    assert Map.has_key?(body[String.to_atom(index_name)][:settings][:index], :analysis)
  end

  test "create filters" do
    index_name = "bear_test"
    index = [index: index_name]
    settings do
      analysis do
        filter "edge_ngram", [type: "edgeNGram", min_gram: 1, max_gram: 15]
      end
    end

    {:ok, _, body} = Tirexs.ElasticSearch.Settings.create_resource(index)
    assert body[:acknowledged] == true

    {:ok, _, body} = Tirexs.bump()._settings(index_name)
    index_settings = body[String.to_atom(index_name)][:settings][:index]
    assert Map.has_key?(index_settings, :analysis)
    assert Map.has_key?(index_settings[:analysis], :filter)
    assert Map.has_key?(index_settings[:analysis][:filter], :edge_ngram)
    edge_ngram_filter = index_settings[:analysis][:filter][:edge_ngram]
    assert edge_ngram_filter == %{ type: "edgeNGram", max_gram: "15", min_gram: "1" }
  end

  test "create analyzers" do
    index_name = "bear_test"
    index = [index: index_name]
    settings do
      analysis do
        analyzer "autocomplete_analyzer", [filter: ["lowercase", "asciifolding"], tokenizer: "whitespace"]
      end
    end

    {:ok, _, body} = Tirexs.ElasticSearch.Settings.create_resource(index)
    assert body[:acknowledged] == true

    {:ok, _, body} = Tirexs.bump()._settings(index_name)
    index_settings = body[String.to_atom(index_name)][:settings][:index]
    assert Map.has_key?(index_settings, :analysis)
    assert Map.has_key?(index_settings[:analysis], :analyzer)
    assert Map.has_key?(index_settings[:analysis][:analyzer], :autocomplete_analyzer)
    autocomplete_analyzer = index_settings[:analysis][:analyzer][:autocomplete_analyzer]
    assert autocomplete_analyzer == %{ filter: ["lowercase", "asciifolding"], tokenizer: "whitespace" }
  end

  test "create tokenizers" do
    index_name = "bear_test"
    index = [index: index_name]
    settings do
      analysis do
        tokenizer "my_tokenizer", [type: "pattern", pattern: "([\\w\\s]+)"]
      end
    end

    {:ok, _, body} = Tirexs.ElasticSearch.Settings.create_resource(index)
    assert body[:acknowledged] == true

    {:ok, _, body} = Tirexs.bump()._settings(index_name)
    index_settings = body[String.to_atom(index_name)][:settings][:index]
    assert Map.has_key?(index_settings, :analysis)
    assert Map.has_key?(index_settings[:analysis], :tokenizer)
    assert Map.has_key?(index_settings[:analysis][:tokenizer], :my_tokenizer)
    my_tokenizer = index_settings[:analysis][:tokenizer][:my_tokenizer]
    assert my_tokenizer == %{ type: "pattern", pattern: "([\\w\\s]+)" }
  end

  test "create char_filters" do
    index_name = "bear_test"
    index = [index: index_name]
    settings do
      analysis do
        char_filter "translations", [type: "mapping", mappings: ["ph => f", "qu => k"]]
      end
    end

    {:ok, _, body} = Tirexs.ElasticSearch.Settings.create_resource(index)
    assert body[:acknowledged] == true

    {:ok, _, body} = Tirexs.bump()._settings(index_name)
    index_settings = body[String.to_atom(index_name)][:settings][:index]
    assert Map.has_key?(index_settings, :analysis)
    assert Map.has_key?(index_settings[:analysis], :char_filter)
    assert Map.has_key?(index_settings[:analysis][:char_filter], :translations)
    translations = index_settings[:analysis][:char_filter][:translations]
    assert translations == %{ type: "mapping", mappings: ["ph => f", "qu => k"] }
  end
end
