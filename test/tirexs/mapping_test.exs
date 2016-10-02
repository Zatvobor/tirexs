Code.require_file "../../test_helper.exs", __ENV__.file

defmodule Tirexs.MappingsTest do
  use ExUnit.Case

  use Tirexs.Mapping


  test "mappings in general" do
    index = [index: "bear_test"]
    mappings do
      indexes "id", [
        type: "multi_field",
        fields: [
          name_en: [ type: "string", analyzer: "analyzer_en", boost: 100],
          exact: [type: "string", index: "not_analyzed"]
        ]
      ]
      indexes "title", type: "string"
    end

    expected = [properties: [id: [type: "multi_field", fields: [name_en: [type: "string", analyzer: "analyzer_en", boost: 100], exact: [type: "string", index: "not_analyzed"]]], title: [type: "string"]]]
    assert index[:mapping] == expected
  end

  test "mappings with extra configurations" do
    index = [index: "bear_test"]
    mappings dynamic: "false", _parent: [type: "parent"] do
      indexes "id", [
        type: "multi_field",
        fields: [
          name_en: [ type: "string", analyzer: "analyzer_en", boost: 100],
          exact: [type: "string", index: "not_analyzed"]
        ]
      ]
      indexes "title", type: "string"
    end

    expected = [dynamic: "false", _parent: [type: "parent"], properties: [id: [type: "multi_field", fields: [name_en: [type: "string", analyzer: "analyzer_en", boost: 100], exact: [type: "string", index: "not_analyzed"]]], title: [type: "string"]]]
    assert index[:mapping] == expected
  end

  test "mappings w/ nested indexes" do
    index = [index: "bear_test"]
    mappings do
      indexes "id", [type: "string", boost: 5, analizer: "good"]
      indexes "title", [type: "nested"] do
        indexes "set", type: "string"
        indexes "get", type: "long"
      end
      indexes "simple", type: "string"
      indexes "simple2", type: "long"
    end

    expected = [properties: [id: [type: "string", boost: 5, analizer: "good"], title: [type: "nested", properties: [set: [type: "string"], get: [type: "long"]]], simple: [type: "string"], simple2: [type: "long"]]]
    assert index[:mapping] == expected
  end

  test "mappings w/ nested indexes (default type)" do
    index = [index: "bear_test"]
    mappings do
      indexes "id", [type: "string", boost: 5, analizer: "good"]
      indexes "title" do
        indexes "set", type: "string"
        indexes "get", type: "long"
      end
      indexes "simple", type: "string"
      indexes "simple2", type: "long"
    end

    expected = [index: "bear_test", mapping: [properties: [id: [type: "string", boost: 5, analizer: "good"], title: [type: "object", properties: [set: [type: "string"], get: [type: "long"]]], simple: [type: "string"], simple2: [type: "long"]]]]
    assert index == expected
  end

  test "mappings w/ deeply nested indexes" do
    index = [index: "bear_test"]
    mappings do
      indexes "id", [type: "string", boost: 5]
      indexes "title", [type: "nested"] do
        indexes "set", [type: "string"] do
          indexes "set2", type: "string"
        end
        indexes "get", type: "long"
      end
      indexes "simple", type: "string"
    end

    expected = [index: "bear_test", mapping: [properties: [id: [type: "string", boost: 5], title: [type: "nested", properties: [set: [type: "string", properties: [set2: [type: "string"]]], get: [type: "long"]]], simple: [type: "string"]]]]
    assert index == expected
  end


  test "mappings example #1" do
    index = [index: "bear_test"]
    mappings do
      indexes "mn_opts_", [type: "nested"] do
        indexes "uk", [type: "nested"] do
          indexes "credentials", [type: "nested"] do
            indexes "available_from", type: "long"
            indexes "buy", type: "nested"
            indexes "dld", type: "nested"
            indexes "str", type: "nested"
            indexes "t2p", type: "nested"
            indexes "sby", type: "nested"
            indexes "spl", type: "nested"
            indexes "spd", type: "nested"
            indexes "pre", type: "nested"
            indexes "fst", type: "nested"
          end
        end
      end
      indexes "rev_history_", type: "nested"
    end

    expected = [index: "bear_test", mapping: [properties: [mn_opts_: [type: "nested", properties: [uk: [type: "nested", properties: [credentials: [type: "nested", properties: [available_from: [type: "long"], buy: [type: "nested"], dld: [type: "nested"], str: [type: "nested"], t2p: [type: "nested"], sby: [type: "nested"], spl: [type: "nested"], spd: [type: "nested"], pre: [type: "nested"], fst: [type: "nested"]]]]]]], rev_history_: [type: "nested"]]]]
    assert index == expected
  end

  test "mappings example #2" do
    index = [index: "bear_test"]
    mappings do
      indexes "mn_opts_", [type: "nested"] do
        indexes "uk", [type: "nested"] do
          indexes "credentials", [type: "nested"] do
            index "available_from", type: "long"
            index "buy", type: "nested"
            index "dld", type: "nested"
            index "str", type: "nested"
            index "t2p", type: "nested"
            index "sby", type: "nested"
            index "spl", type: "nested"
            index "spd", type: "nested"
            index "pre", type: "nested"
            index "fst", type: "nested"
          end
        end
        indexes "ca", [type: "nested"] do
          indexes "credentials", [type: "nested"] do
            index "available_from", type: "long"
            index "buy", type: "nested"
            index "dld", type: "nested"
            index "str", type: "nested"
            index "t2p", type: "nested"
            index "sby", type: "nested"
            index "spl", type: "nested"
            index "spd", type: "nested"
            index "pre", type: "nested"
            index "fst", type: "nested"
          end
        end
        indexes "us", [type: "nested"] do
          indexes "credentials", [type: "nested"] do
            index "available_from", type: "long"
            index "buy", type: "nested"
            index "dld", type: "nested"
            index "str", type: "nested"
            index "t2p", type: "nested"
            index "sby", type: "nested"
            index "spl", type: "nested"
            index "spd", type: "nested"
            index "pre", type: "nested"
            index "fst", type: "nested"
          end
        end
      end
      index "rev_history_", type: "nested"
    end

    expected = [index: "bear_test", mapping: [properties: [mn_opts_: [type: "nested", properties: [uk: [type: "nested", properties: [credentials: [type: "nested", properties: [available_from: [type: "long"], buy: [type: "nested"], dld: [type: "nested"], str: [type: "nested"], t2p: [type: "nested"], sby: [type: "nested"], spl: [type: "nested"], spd: [type: "nested"], pre: [type: "nested"], fst: [type: "nested"]]]]], ca: [type: "nested", properties: [credentials: [type: "nested", properties: [available_from: [type: "long"], buy: [type: "nested"], dld: [type: "nested"], str: [type: "nested"], t2p: [type: "nested"], sby: [type: "nested"], spl: [type: "nested"], spd: [type: "nested"], pre: [type: "nested"], fst: [type: "nested"]]]]], us: [type: "nested", properties: [credentials: [type: "nested", properties: [available_from: [type: "long"], buy: [type: "nested"], dld: [type: "nested"], str: [type: "nested"], t2p: [type: "nested"], sby: [type: "nested"], spl: [type: "nested"], spd: [type: "nested"], pre: [type: "nested"], fst: [type: "nested"]]]]]]], rev_history_: [type: "nested"]]]]
    assert index == expected
  end

  test "put mapping and settings together" do
    index = [index: "bear_test"]
    settings do
      analysis do
        filter "edge_ngram", [type: "edgeNGram", min_gram: 1, max_gram: 15]
        analyzer "autocomplete_analyzer",
        [
          filter: ["icu_normalizer", "icu_folding", "edge_ngram"],
          tokenizer: "icu_tokenizer"
        ]
      end
    end

    mappings do
      indexes "id", [
        type: "multi_field",
        fields: [
          name_en: [type: "string", analyzer: "analyzer_en", boost: 100],
          exact: [type: "string", index: "not_analyzed"]
        ]
      ]
      indexes "title", type: "string"
    end

    expected = [properties: [id: [type: "multi_field", fields: [name_en: [type: "string", analyzer: "analyzer_en", boost: 100], exact: [type: "string", index: "not_analyzed"]]], title: [type: "string"]]]
    assert index[:mapping] == expected

    expected = [analysis: [analyzer: [autocomplete_analyzer: [filter: ["icu_normalizer", "icu_folding", "edge_ngram"], tokenizer: "icu_tokenizer"]], filter: [edge_ngram: [type: "edgeNGram", min_gram: 1, max_gram: 15]]], index: []]
    assert index[:settings] == expected
  end
end
