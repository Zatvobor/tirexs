defmodule Tirexs.Mapping.Json do

  def to_json_proplist(hash_dict, :mapping) do
    key = get_root_level_key(hash_dict)
    to_convert_dict = root_level(hash_dict, key)
    delete_root_level_type(mapping_from_hash_dict_to_list(to_convert_dict), key)
  end

  def mapping_from_hash_dict_to_list(hash_dict) do
      Enum.map hash_dict.keys(), fn(el) ->
        element = hash_dict[el]
        case is_hash_dict?(element) do
          true -> [el, mapping_from_hash_dict_to_list(element)]
          false -> case is_list(element) do
            true ->
              if element[:properties] != nil do
                mapping_from_properties(element)
              else
                Dict.put([], binary_to_atom(element[:name]), delete_system_attrs(element))
              end
            false -> [el, element]
          end
        end
      end
    end


  defp mapping_from_properties(element) do
    properties = Enum.map element[:properties], fn(x) ->
      mapping_from_hash_dict_to_list(x)
    end
    properties = List.flatten properties
    Dict.put([], binary_to_atom(element[:name]), delete_system_attrs(element) ++ [properties: properties])
  end

  defp delete_system_attrs(dict) do
    dict = Dict.delete(dict, :deep)
    dict = Dict.delete(dict, :name)
    Dict.delete(dict, :properties)
  end

  defp get_root_level_key(hash_dict) do
    if hash_dict[:type] == nil do
      hash_dict[:name]
    else
      hash_dict[:type]
    end
  end

  defp is_hash_dict?(dict), do: is_record(dict, HashDict) || false

  defp root_level(hash_dict, key) do
    HashDict.new([index: [name: key, properties: hash_dict[:mappings]]])
  end

  defp delete_root_level_type([json_dict], key) do
    dict = Dict.delete(json_dict[binary_to_atom(key)], :type)
    Dict.put([], binary_to_atom(key), dict)
  end
end