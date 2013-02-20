Code.require_file "../test_helper.exs", __FILE__

defmodule MappingsTest do
  use ExUnit.Case

  import Tirexs
  use Tirexs.Mapping
  import UidFinder

  test :simpe_dsl do
    index = create_index([name: "bear_test"]) #important index varible are using in dsl!
    settings "settings"  do
      mappings do
        indexes "id", [type: "string", boost: 5, analizer: "good"]
        indexes "title", type: "string"
      end
    end

    assert index[:mappings] == [HashDict.new([{UidFinder.first, [name: "id", type: "string", boost: 5, analizer: "good"]}]), HashDict.new([{UidFinder.last, [name: "title", type: "string"]}])]
  end

  test :nested_two_level_index_dsl do
    index = create_index([name: "bear_test"]) #important index varible are using in dsl!
    settings "settings"  do
      mappings do
        indexes "id", [type: "string", boost: 5, analizer: "good"]
        indexes "title", [type: "nested"] do
          indexes "set", type: "string"
          indexes "get", type: "long"
        end
        indexes "simple", type: "string"
        indexes "simple2", type: "long"
      end
    end

    simple_index = HashDict.new([{UidFinder.first, [name: "id", type: "string", boost: 5, analizer: "good"]}])
    title_uid = UidFinder.find(1)
    all_nested_uids = UidFinder.next_all(title_uid)
    advance_index = HashDict.new([{title_uid, [properties: [HashDict.new([{at!(all_nested_uids, 0), [name: "set", type: "string"]}]),HashDict.new([{UidFinder.at!(all_nested_uids, 1), [name: "get", type: "long"]}])], type: "nested", name: "title"]}])
    simple_index2 = HashDict.new([{UidFinder.find(2), [name: "simple", type: "string"]}])
    simple_index3 = HashDict.new([{UidFinder.last, [name: "simple2", type: "long"]}])
    assert index[:mappings] == [simple_index, advance_index, simple_index2, simple_index3]
  end


  test :default_type do
    index = create_index([name: "bear_test"]) #important index varible are using in dsl!
    settings "settings"  do
      mappings do
        index "id", [type: "string", boost: 5, analizer: "good"]
        indexes "title" do
          indexes "set", type: "string"
          indexes "get", type: "long"
        end
        indexes "simple", type: "string"
        indexes "simple2", type: "long"
      end
    end

    # IO.puts inspect(index[:mappings])

    simple_index = HashDict.new([{UidFinder.first, [name: "id", type: "string", boost: 5, analizer: "good"]}])
    title_uid = UidFinder.find(1)
    all_nested_uids = UidFinder.next_all(title_uid)
    advance_index = HashDict.new([{title_uid, [properties: [HashDict.new([{at!(all_nested_uids, 0), [name: "set", type: "string"]}]),HashDict.new([{UidFinder.at!(all_nested_uids, 1), [name: "get", type: "long"]}])], type: "object", name: "title"]}])
    simple_index2 = HashDict.new([{UidFinder.find(2), [name: "simple", type: "string"]}])
    simple_index3 = HashDict.new([{UidFinder.last, [name: "simple2", type: "long"]}])
    assert index[:mappings] == [simple_index, advance_index, simple_index2, simple_index3]

  end

  test :nested_deep_index_dsl do
    index = create_index([name: "bear_test"]) #important index varible are using in dsl!
    settings "settings"  do
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
    end

    simple_index = HashDict.new([{UidFinder.first, [name: "id", type: "string", boost: 5]}])
    title_uid = UidFinder.find(1)
    all_nested_title_uids = UidFinder.next_all(title_uid)
    set_uid = UidFinder.at!(all_nested_title_uids, 0)
    set_uids = UidFinder.next_all(set_uid)
    deep_index = HashDict.new([{title_uid, [properties: [HashDict.new([{set_uid, [properties: [HashDict.new([{at!(set_uids, 0), [name: "set2", type: "string"]}])], type: "string", name: "set"]}]), HashDict.new([{at!(all_nested_title_uids, 1), [name: "get", type: "long"]}])],type: "nested", name: "title"  ]}])
    simple_index2 = HashDict.new([{UidFinder.last, [name: "simple", type: "string"]}])
    assert index[:mappings] == [simple_index, deep_index, simple_index2]

  end


  test :real_simpe_example do
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
        end
        indexes "rev_history_", type: "nested"
      end
    end

    mn_opts_uid = UidFinder.first
    uk_uid = UidFinder.next(mn_opts_uid, 0)
    credentials_uid = UidFinder.next(uk_uid, 0)
    credentional_uids = UidFinder.next_all(credentials_uid)

    rev_history = HashDict.new([{UidFinder.last, [name: "rev_history_", type: "nested"]}])
    add_list = [HashDict.new([{at!(credentional_uids, 0), [name: "available_from", type: "long"]}]), HashDict.new([{at!(credentional_uids, 1), [name: "buy", type: "nested"]}]), HashDict.new([{at!(credentional_uids, 2), [name: "dld", type: "nested"]}]), HashDict.new([{at!(credentional_uids, 3), [name: "str", type: "nested"]}])]
    add_list = add_list ++ [HashDict.new([{at!(credentional_uids, 4), [name: "t2p", type: "nested"]}]), HashDict.new([{at!(credentional_uids, 5), [name: "sby", type: "nested"]}]), HashDict.new([{at!(credentional_uids, 6), [name: "spl", type: "nested"]}]), HashDict.new([{at!(credentional_uids, 7), [name: "spd", type: "nested"]}])]
    add_list = add_list ++ [HashDict.new([{at!(credentional_uids, 8), [name: "pre", type: "nested"]}]), HashDict.new([{at!(credentional_uids, 9), [name: "fst", type: "nested"]}])]
    real_index = HashDict.new([{mn_opts_uid, [properties: [HashDict.new([{uk_uid, [properties: [HashDict.new([{credentials_uid,[properties: add_list, type: "nested", name: "credentials"]}])], type: "nested", name: "uk" ]}]) ], type: "nested", name: "mn_opts_"]}])

    assert index[:mappings] == [real_index, rev_history]

  end

  test :real_advance_exampe do
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

    mn_opts_uid = UidFinder.first



    rev_history = HashDict.new([{UidFinder.last, [name: "rev_history_", type: "nested"]}])

    #for uk mapping
    uk_uid = UidFinder.next(mn_opts_uid, 0)
    credentials_uid = UidFinder.next(uk_uid, 0)
    credentional_uids = UidFinder.next_all(credentials_uid)

    uk_add_list = [HashDict.new([{at!(credentional_uids, 0), [name: "available_from", type: "long"]}]), HashDict.new([{at!(credentional_uids, 1), [name: "buy", type: "nested"]}]), HashDict.new([{at!(credentional_uids, 2), [name: "dld", type: "nested"]}]), HashDict.new([{at!(credentional_uids, 3), [name: "str", type: "nested"]}])]
    uk_add_list = uk_add_list ++ [HashDict.new([{at!(credentional_uids, 4), [name: "t2p", type: "nested"]}]), HashDict.new([{at!(credentional_uids, 5), [name: "sby", type: "nested"]}]), HashDict.new([{at!(credentional_uids, 6), [name: "spl", type: "nested"]}]), HashDict.new([{at!(credentional_uids, 7), [name: "spd", type: "nested"]}])]
    uk_add_list = uk_add_list ++ [HashDict.new([{at!(credentional_uids, 8), [name: "pre", type: "nested"]}]), HashDict.new([{at!(credentional_uids, 9), [name: "fst", type: "nested"]}])]
    uk_list = HashDict.new([{uk_uid, [properties: [HashDict.new([{credentials_uid,[properties: uk_add_list, type: "nested", name: "credentials"]}])], type: "nested", name: "uk" ]}])

    #for ca mapping
    ca_uid = UidFinder.next(mn_opts_uid, 1)
    credentials_uid = UidFinder.next(ca_uid, 0)
    credentional_uids = UidFinder.next_all(credentials_uid)
    ca_add_list = [HashDict.new([{at!(credentional_uids, 0), [name: "available_from", type: "long"]}]), HashDict.new([{at!(credentional_uids, 1), [name: "buy", type: "nested"]}]), HashDict.new([{at!(credentional_uids, 2), [name: "dld", type: "nested"]}]), HashDict.new([{at!(credentional_uids, 3), [name: "str", type: "nested"]}])]
    ca_add_list = ca_add_list ++ [HashDict.new([{at!(credentional_uids, 4), [name: "t2p", type: "nested"]}]), HashDict.new([{at!(credentional_uids, 5), [name: "sby", type: "nested"]}]), HashDict.new([{at!(credentional_uids, 6), [name: "spl", type: "nested"]}]), HashDict.new([{at!(credentional_uids, 7), [name: "spd", type: "nested"]}])]
    ca_add_list = ca_add_list ++ [HashDict.new([{at!(credentional_uids, 8), [name: "pre", type: "nested"]}]), HashDict.new([{at!(credentional_uids, 9), [name: "fst", type: "nested"]}])]
    ca_list = HashDict.new([{ca_uid, [properties: [HashDict.new([{credentials_uid,[properties: ca_add_list, type: "nested", name: "credentials"]}])], type: "nested", name: "ca" ]}])

    #for us mapping
    us_uid = UidFinder.next(mn_opts_uid, 2)
    credentials_uid = UidFinder.next(us_uid, 0)
    credentional_uids = UidFinder.next_all(credentials_uid)
    us_add_list = [HashDict.new([{at!(credentional_uids, 0), [name: "available_from", type: "long"]}]), HashDict.new([{at!(credentional_uids, 1), [name: "buy", type: "nested"]}]), HashDict.new([{at!(credentional_uids, 2), [name: "dld", type: "nested"]}]), HashDict.new([{at!(credentional_uids, 3), [name: "str", type: "nested"]}])]
    us_add_list = us_add_list ++ [HashDict.new([{at!(credentional_uids, 4), [name: "t2p", type: "nested"]}]), HashDict.new([{at!(credentional_uids, 5), [name: "sby", type: "nested"]}]), HashDict.new([{at!(credentional_uids, 6), [name: "spl", type: "nested"]}]), HashDict.new([{at!(credentional_uids, 7), [name: "spd", type: "nested"]}])]
    us_add_list = us_add_list ++ [HashDict.new([{at!(credentional_uids, 8), [name: "pre", type: "nested"]}]), HashDict.new([{at!(credentional_uids, 9), [name: "fst", type: "nested"]}])]
    us_list = HashDict.new([{us_uid, [properties: [HashDict.new([{credentials_uid,[properties: us_add_list, type: "nested", name: "credentials"]}])], type: "nested", name: "us" ]}])

    real_index = HashDict.new([{mn_opts_uid, [properties: [uk_list, ca_list, us_list], type: "nested", name: "mn_opts_"]}])

    assert index[:mappings] == [real_index, rev_history]

  end

end
