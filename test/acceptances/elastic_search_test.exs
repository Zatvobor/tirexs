Code.require_file "../../test_helper.exs", __FILE__

defmodule ElasticSearchTest do

  use ExUnit.Case
  import Tirexs
  use Tirexs.Mapping
  import Tirexs.ElasticSearch


  test :get_elastic_search_server do
    settings = Tirexs.ElasticSearch.Config.new()
    [body, _, _] = get("missing_index", settings)

    assert body == :error

    body = get("/", settings)
    body = ParserResponse.get_body_json(body)

    assert body["tagline"] == "You Know, for Search"

  end

  test :create_index do
    settings = Tirexs.ElasticSearch.Config.new()
    delete("bear_test", settings)
    new_index = put("bear_test", settings)
    body = ParserResponse.get_body_json(new_index)
    assert body["acknowledged"] == true
  end

  test :delete_index do
    settings = Tirexs.ElasticSearch.Config.new()
    put("bear_test", settings)
    deleted_index = delete("bear_test", settings)
    body = ParserResponse.get_body_json(deleted_index)
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
    index = init_index([name: "bear_test", type: "bear_type"]) #important index varible are using in dsl!
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

    new_mapping = Tirexs.Mapping.create_resource(index, settings)

    body = ParserResponse.get_body_json(new_mapping)
    assert body["acknowledged"] == true

    delete("bear_test", settings)
  end

end