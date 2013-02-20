defmodule Tirexs.Mapping.Helpers do

  def get_last_deep_mapping(mapping) do
    key = List.last mapping.keys
    if mapping[key][:properties] == nil || Enum.empty? mapping[key][:properties] do
      mapping
    else
      property = List.last mapping[key][:properties]
      property_key = key(property)
      if property[property_key][:deep] == nil do
        mapping
      else
        get_last_deep_mapping(property)
      end
    end
  end

  def get_deep_mapping_by_name(nil, _name) do
    []
  end

  def get_deep_mapping_by_name(mapping, name) do
    Enum.map mapping, fn(x) ->
      key = key(x)
      if x[name] != nil && x[name][:deep] == true do
        x
      else
        get_deep_mapping_by_name(x[key][:properties], name)
      end
    end
  end

  def get_parent_deep_mapping_by_name(nil, _name, _parent_key) do
    []
  end

  def get_parent_deep_mapping_by_name(mapping, name, parent_key) do
    Enum.map mapping, fn(x) ->
      key = key(x)
      if x[name] != nil do
        parent_key
      else
        get_parent_deep_mapping_by_name(x[key][:properties], name, key)
      end
    end
  end


  defmacro get_last_deep_mapping do
    quote do
      mapping = List.last var!(index)[:mappings]
      if mapping == nil do
        mapping
      else
        get_last_deep_mapping(mapping)
      end
    end
  end

  defmacro get_deep_mapping_by_name(name) do
    quote do
      name = unquote(name)
      mapping = var!(index)[:mappings]
      if Enum.empty? mapping do
        mapping
      else
        Enum.first(List.flatten get_deep_mapping_by_name(mapping, name))
      end
    end
  end

  defmacro recursive_update_mapping(keys_for_update, dict) do
    quote do
      keys_for_update = Enum.reverse unquote(keys_for_update)
      dict = unquote(dict)
      recursive_update_mapping(keys_for_update, var!(index)[:mappings], dict)
    end
  end


  def recursive_update_mapping([], _mappings, dict) do
    dict
  end

  def recursive_update_mapping([h|t], mappings, dict) do
    dict_for_update = Enum.first List.flatten(get_deep_mapping_by_name(mappings, h))
    key = key(dict_for_update)
    dict_update_key = key(dict)
    properties = dict_for_update[key][:properties]
    properties = Enum.map properties, fn(prop) ->
      prop_key = key(prop)
      if prop_key == dict_update_key do
        dict
      else
        prop
      end
    end

    if Enum.empty? properties do
      recursive_update_mapping(t, mappings, dict)
    else
      update_list = Dict.put(dict_for_update[key], :properties, properties)
      updated_dict = HashDict.put(dict_for_update, key, update_list)
      recursive_update_mapping(t, mappings, updated_dict)
    end
  end


  defmacro keys_tree(name, with_last) do
    quote do
      name = unquote(name)
      [h | keys] = Enum.reverse keys_tree(name, var!(index)[:mappings], [])
      case unquote(with_last) do
        true -> keys ++ [name]
        false -> keys
      end
    end
  end


  def keys_tree(name, mappings, acc) do
    acc = acc ++ [Enum.first List.flatten(get_parent_deep_mapping_by_name(mappings, name, name))]
    if List.last(acc) != name do
      acc = keys_tree(List.last(acc), mappings, acc)
    else
      acc
    end
  end

  def key(dict) do
    Enum.first dict.keys
  end

  def uid do
    {_,_, uid} = :erlang.now()
    to_binary(uid)
  end

end