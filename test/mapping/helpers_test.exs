Code.require_file "../../test_helper.exs", __FILE__

defmodule Mapping.HelpersTest do
  use ExUnit.Case

  import Tirexs
  use Tirexs.Mapping

  test :get_last_deep_mapping do
    index = init_index([name: "bear_test"])
    mappings = [HashDict.new([{"a", []}]), HashDict.new([{"b", [deep: true, properties: [HashDict.new([{"c", [deep: true]}])]]}])]
    index = HashDict.put(index, :mappings, mappings)
    assert get_last_deep_mapping() == HashDict.new([{"c", [deep: true]}])
  end

  test :get_deep_mapping_by_name do
    index = init_index([name: "bear_test"])
    mappings = [HashDict.new([{"a", []}]), HashDict.new([{"b", [deep: true, properties: [HashDict.new([{"c", [deep: true]}])]]}])]
    index = HashDict.put(index, :mappings, mappings)
    assert get_deep_mapping_by_name("c") == HashDict.new([{"c", [deep: true]}])
  end

  test :keys_tree do
    index = init_index([name: "bear_test"])
    mappings = [HashDict.new([{"a", [properties: [HashDict.new([{"f",[]}])]]}]), HashDict.new([{"b", [deep: true, properties: [HashDict.new([{"c", [deep: true, properties: [HashDict.new([{"v",[deep: true]}])] ]}])]]}])]
    index = HashDict.put(index, :mappings, mappings)
    assert keys_tree("a", true) == ["a"]
    assert keys_tree("f", true) == ["a", "f"]
    assert keys_tree("v", true) == ["b", "c", "v"]
     assert keys_tree("v", false) == ["b", "c"]
    assert keys_tree("c", true) == ["b", "c"]
    assert keys_tree("b", true) == ["b"]
  end

  test :recursive_update_mapping do
    index = init_index([name: "bear_test"])
    mappings = [HashDict.new([{"a", [deep: true, properties: [HashDict.new([{"f",[]}])]]}])]
    index = HashDict.put(index, :mappings, mappings)
    keys = keys_tree("f", false)
    assert keys == ["a"]
    assert recursive_update_mapping(keys, HashDict.new([{"f",[list: true]}])) == HashDict.new([{"a", [properties: [HashDict.new([{"f",[list: true]}])], deep: true]}])

    mappings = [HashDict.new([{"a", [properties: [HashDict.new([{"f",[]}])]]}]), HashDict.new([{"b", [deep: true, properties: [HashDict.new([{"c", [deep: true, properties: [HashDict.new([{"v",[deep: true]}])] ]}])]]}])]
    index = HashDict.put(index, :mappings, mappings)
    keys = keys_tree("v", false)
    assert keys == ["b", "c"]
    assert recursive_update_mapping(keys, HashDict.new([{"v",[list: true]}])) == HashDict.new([{"b", [properties: [HashDict.new([{"c", [properties: [HashDict.new([{"v",[list: true]}])], deep: true]}])], deep: true]}])
  end

end
