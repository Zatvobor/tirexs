defmodule Tirexs.Helpers do

  def to_atom(value) when is_atom(value) do
    value
  end

  def to_atom(value) when is_binary(value) do
    binary_to_atom(value)
  end

  def to_atom(value) do
    value
  end

  def is_dict?(dict) do
    is_record(dict, Dict) || false
  end


  def get_clear_block([]) do
    []
  end

  def get_clear_block(block) do
    case block do
      {:__block__, _, block_list} -> block_list
      _ -> block
    end
  end

  def to_array(dict) do
    to_array(dict, [])
  end

  def to_array([], acc) do
    acc
  end

  def to_array([h|t], acc) do
    to_array(t, acc ++ [[h]])
  end

  def get_options(options) do
    if Dict.size(options) > 2 do
      Enum.at!(options, 2)
    else
      []
    end
  end

  def extract_options(params) do
    if Dict.size(params) > 1 do
      [Enum.at!(params, 0), Enum.at!(params, 1), get_options(params)]
    else
      [Enum.at!(params, 0), [],[]]
    end
  end

  def extract_do(block, position//0) do
    element = Enum.at!(block, position)
    if element[:do] != nil do
      element[:do]
    else
      element
    end
  end
end