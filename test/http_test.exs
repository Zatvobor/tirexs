Code.require_file "../test_helper.exs", __FILE__

defmodule HTTPTest do
  use ExUnit.Case
  import Tirexs
  use Tirexs.Mapping
  use Tirexs.ElasticSettings
  import Tirexs.Mapping.Json
  import Tirexs.HTTP

  test :get_elastic_search_server do
    settings = elastic_settings.new([uri: "localhost"])
    [body, _, _] = get(settings, "missing_index")

    assert body == :error

    body = get(settings, "/")
    body = ParserResponse.get_body_json(body)

    assert body["tagline"] == "You Know, for Search"

  end

  test :create_index do
    settings = elastic_settings.new([uri: "localhost"])
    delete(settings, "bear_test")
    new_index = put(settings, "bear_test", [])
    body = ParserResponse.get_body_json(new_index)
    assert body["acknowledged"] == true
  end

  test :delete_index do
    settings = elastic_settings.new([uri: "localhost"])
    put(settings, "bear_test", [])
    deleted_index = delete(settings, "bear_test")
    body = ParserResponse.get_body_json(deleted_index)
    assert body["acknowledged"] == true
  end


  test :head do
    settings = elastic_settings.new([uri: "localhost"])
    assert exist?(settings, "bear_test") == false
    put(settings, "bear_test", [])
    assert exist?(settings, "bear_test") == true
    delete(settings, "bear_test")
  end

  test :create_type_mapping do
    settings = elastic_settings.new([uri: "localhost"])
    index = init_index([name: "bear_test", type: "bear_type"]) #important index varible are using in dsl!
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

    new_mapping = put_mapping(settings, index)

    body = ParserResponse.get_body_json(new_mapping)
    assert body["acknowledged"] == true

    delete(settings, "bear_test")
  end

end