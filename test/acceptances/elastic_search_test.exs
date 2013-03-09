Code.require_file "../../test_helper.exs", __FILE__

defmodule ElasticSearchTest do

  use ExUnit.Case
  use Tirexs.Mapping
  import Tirexs.ElasticSearch


  test :get_elastic_search_server do
    settings = Tirexs.ElasticSearch.Config.new()
    [status, _, _] = get("missing_index", settings)

    assert status == :error

    [_, _, body] = get("", settings)

    assert body["tagline"] == "You Know, for Search"

  end

  test :create_index do
    settings = Tirexs.ElasticSearch.Config.new()
    delete("bear_test", settings)
    [_, _, body] = put("bear_test", settings)
    assert body["acknowledged"] == true
    delete("bear_test", settings)
  end

  test :delete_index do
    settings = Tirexs.ElasticSearch.Config.new()
    put("bear_test", settings)
    [_, _, body] = delete("bear_test", settings)
    assert body["acknowledged"] == true
  end


  test :head do
    settings = Tirexs.ElasticSearch.Config.new()
    assert exist?("bear_test", settings) == false
    put("bear_test", settings)
    assert exist?("bear_test", settings) == true
    delete("bear_test", settings)
  end

  test :create_type_mapping do
    settings = Tirexs.ElasticSearch.Config.new()
    index = [name: "bear_test", type: "bear_type"]
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

    [_, _, body] = Tirexs.Mapping.create_resource(index, settings)

    assert body["acknowledged"] == true

    delete("bear_test", settings)
  end

end