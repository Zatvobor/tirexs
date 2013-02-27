Code.require_file "../test_helper.exs", __FILE__

defmodule MappingsTest do
  use ExUnit.Case

  import Tirexs
  use Tirexs.Mapping
  import Tirexs.Mapping.Json
  import UidFinder

  test :simpe_dsl do
    index = init_index([name: "bear_test"]) #important index varible are using in dsl!
    index = mappings do
      indexes "id", [type: "multi_field", fields: [name_en: [type: "string", analyzer: "analyzer_en", boost: 100],
                                                  exact: [type: "string", index: "not_analyzed"]]]
      indexes "title", type: "string"
    end
    assert index[:mapping] == [properties: [id: [type: "multi_field", fields: [name_en: [type: "string", analyzer: "analyzer_en", boost: 100], exact: [type: "string", index: "not_analyzed"]]], title: [type: "string"]]]
  end

  test :nested_two_level_index_dsl do
    index = init_index([name: "bear_test"]) #important index varible are using in dsl!
    mappings = mappings do
      indexes "id", [type: "string", boost: 5, analizer: "good"]
      indexes "title", [type: "nested"] do
        indexes "set", type: "string"
        indexes "get", type: "long"
      end
      indexes "simple", type: "string"
      indexes "simple2", type: "long"
    end

    assert index[:mapping] == [properties: [id: [type: "string", boost: 5, analizer: "good"], title: [type: "nested", properties: [set: [type: "string"], get: [type: "long"]]], simple: [type: "string"], simple2: [type: "long"]]]
  end

  test :default_type do
    index = init_index([name: "bear_test"]) #important index varible are using in dsl!
    index = mappings do
      indexes "id", [type: "string", boost: 5, analizer: "good"]
      indexes "title" do
        indexes "set", type: "string"
        indexes "get", type: "long"
      end
      indexes "simple", type: "string"
      indexes "simple2", type: "long"
    end

    assert index == [name: "bear_test", mapping: [properties: [id: [type: "string", boost: 5, analizer: "good"], title: [type: "object", properties: [set: [type: "string"], get: [type: "long"]]], simple: [type: "string"], simple2: [type: "long"]]]]
  end
  #
  test :nested_deep_index_dsl do
    index = init_index([name: "bear_test"]) #important index varible are using in dsl!
   index =  mappings do
      indexes "id", [type: "string", boost: 5]
      indexes "title", [type: "nested"] do
        indexes "set", [type: "string"] do
          indexes "set2", type: "string"
        end
        indexes "get", type: "long"
      end
      indexes "simple", type: "string"
    end

    assert index ==  [name: "bear_test", mapping: [properties: [id: [type: "string", boost: 5], title: [type: "nested", properties: [set: [type: "string", properties: [set2: [type: "string"]]], get: [type: "long"]]], simple: [type: "string"]]]]
  end


  test :real_simpe_example do
    index = init_index([name: "bear_test"]) #important index varible are using in dsl!
    index = mappings do
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
    assert index == [name: "bear_test", mapping: [properties: [mn_opts_: [type: "nested", properties: [uk: [type: "nested", properties: [credentials: [type: "nested", properties: [available_from: [type: "long"], buy: [type: "nested"], dld: [type: "nested"], str: [type: "nested"], t2p: [type: "nested"], sby: [type: "nested"], spl: [type: "nested"], spd: [type: "nested"], pre: [type: "nested"], fst: [type: "nested"]]]]]]], rev_history_: [type: "nested"]]]]

  end

  test :real_advance_exampe do
      index = init_index([name: "bear_test"]) #important index varible are using in dsl!
      index = mappings do
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
          indexes "ca", [type: "nested"] do
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
          indexes "us", [type: "nested"] do
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

      assert index == [name: "bear_test", mapping: [properties: [mn_opts_: [type: "nested", properties: [uk: [type: "nested", properties: [credentials: [type: "nested", properties: [available_from: [type: "long"], buy: [type: "nested"], dld: [type: "nested"], str: [type: "nested"], t2p: [type: "nested"], sby: [type: "nested"], spl: [type: "nested"], spd: [type: "nested"], pre: [type: "nested"], fst: [type: "nested"]]]]], ca: [type: "nested", properties: [credentials: [type: "nested", properties: [available_from: [type: "long"], buy: [type: "nested"], dld: [type: "nested"], str: [type: "nested"], t2p: [type: "nested"], sby: [type: "nested"], spl: [type: "nested"], spd: [type: "nested"], pre: [type: "nested"], fst: [type: "nested"]]]]], us: [type: "nested", properties: [credentials: [type: "nested", properties: [available_from: [type: "long"], buy: [type: "nested"], dld: [type: "nested"], str: [type: "nested"], t2p: [type: "nested"], sby: [type: "nested"], spl: [type: "nested"], spd: [type: "nested"], pre: [type: "nested"], fst: [type: "nested"]]]]]]], rev_history_: [type: "nested"]]]]
    end

end
