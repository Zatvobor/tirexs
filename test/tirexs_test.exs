Code.require_file "../test_helper.exs", __FILE__

defmodule TirexsTest do
  use ExUnit.Case
  import Tirexs
  import Tirexs.HTTP
  use Tirexs.Mapping
  use Tirexs.ElasticSettings

  test :put_mapping do
    settings = elastic_settings.new([uri: "localhost"])
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

    new_mapping = put_mapping(settings, index)
    body = ParserResponse.get_body_json(new_mapping)
    assert body["acknowledged"] == true
    delete(settings, "bear_test")
  end
end