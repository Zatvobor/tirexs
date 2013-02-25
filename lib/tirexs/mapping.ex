defmodule Tirexs.Mapping do
  defmacro __using__(_) do
    quote do
      import unquote(Tirexs.Mapping)
      import unquote(Tirexs.Mapping.Helpers)
      import unquote(Tirexs.Helpers)
      import unquote(Tirexs.HTTP)
    end
  end

  defmacro mappings([do: block]) do
    quote do
      var!(index) = HashDict.put(var!(index), :mappings, [])
      unquote(block)
    end
  end

  defmacro indexes(name, [do: block]) do
    quote do
      name = unquote(name)
      type_list = [type: "object"]
      indexes name, type_list do
        unquote(block)
      end
    end
  end

  defmacro indexes(name, type_list) do
    quote do
      [name, type_list] = [unquote(name), unquote(type_list)]
      type_list = Dict.put(type_list, :name, name)
      uid_attr = uid()
      if check_deep_mapping do
        add_nested_mapping(HashDict.new([{uid_attr, type_list}]))
      else
        mappings = var!(index)[:mappings] ++ [HashDict.new([{uid_attr, type_list}])]
        var!(index) = HashDict.put(var!(index), :mappings, mappings)
      end
    end
  end


  defmacro indexes(name, type_list, [do: block]) do
    quote do
      [name, type_list] = [unquote(name), unquote(type_list)]
      type_list = type_list ++ [properties: [], name: name, deep: true]
      uid_attr = uid()
      if check_deep_mapping do
        add_nested_mapping(HashDict.new([{uid_attr, type_list}]))
      else
        mappings = var!(index)[:mappings] ++ [HashDict.new([{uid_attr, type_list}])]
        var!(index) = HashDict.put(var!(index), :mappings, mappings)
      end
      unquote(block)
      delete_deep_attr
    end
  end

  defmacro index(name, type_list) do
    quote do
      [name, type_list] = [unquote(name), unquote(type_list)]
      indexes(name, type_list)
    end
  end


  defmacro check_deep_mapping do
    quote do
      mapping = get_last_deep_mapping
      if mapping == nil do
        false
      else
        key = key(mapping)
        Dict.has_key? get_last_deep_mapping[key], :deep
      end
    end
  end

  defmacro add_nested_mapping(mapping) do
    quote do
      mapping = unquote(mapping)
      index = get_last_deep_mapping
      key = key(index)
      keys = keys_tree(key, false)
      properties = (index[key][:properties] ++ [mapping])
      type_list = index[key]
      nested_mapping_list = Dict.put(type_list, :properties, properties)
      if Enum.empty? keys do
        updated_nested = HashDict.new([{key, nested_mapping_list}])
      else
        updated_nested = recursive_update_mapping(keys, HashDict.new([{key, nested_mapping_list}]))
      end
      var!(index) = HashDict.put(var!(index), :mappings, replace_mapping(key, updated_nested))
    end
  end

  defmacro delete_deep_attr do
    quote do
      index = get_last_deep_mapping
      key = key(index)
      keys = keys_tree(key, false)
      nested_index = Dict.delete(index[key], :deep)
      nested_index = HashDict.new([{key, nested_index}])
      if Enum.empty? keys do
        updated_nested = nested_index
      else
        updated_nested = recursive_update_mapping(keys, nested_index)
      end
      var!(index) = HashDict.put(var!(index), :mappings, replace_mapping(key, updated_nested))
    end
  end

  defmacro replace_mapping(name, nested_index) do
    quote do
      [name, nested_index] = [unquote(name), unquote(nested_index)]
      mappings = var!(index)[:mappings]
      [_ | reverse_mappings] = Enum.reverse mappings
      mappings = Enum.reverse reverse_mappings
      mappings ++ [nested_index]
    end
  end

end