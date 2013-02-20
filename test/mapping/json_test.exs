Code.require_file "../../test_helper.exs", __FILE__

defmodule MappingJsonTest do
  use ExUnit.Case
  import Tirexs
  use Tirexs.Mapping
  use Tirexs.ElasticSettings
  import Tirexs.Mapping.Json

  test :to_json_proplist do
    index = create_index([name: "bear_test"]) #important index varible are using in dsl!
    settings "settings" do
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
       end

    json_dict = to_json_proplist(index, :mapping)

    json = :erlson.from_nested_proplist(json_dict)

    from_json = :erlson.from_json(:erlson.to_json(json))

    assert Dict.size(json_dict) == Dict.size(from_json)

  end

end