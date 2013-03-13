defmodule Tirexs.DSL.Logic do
  @moduledoc """
  Defines a main module which provides a common contract for DSL handlers and common utilities.
  """

  ## Logic macros

  @doc false
  defmacro extract(block), do: extract(get_clear_block(block), [])

  @doc false
  defp extract([], acc), do: acc
  defp extract([h|t], acc), do: extract(get_clear_block(t), acc ++ transpose(h))
  defp extract(item, acc), do: acc ++ transpose(item)

  @doc false
  defp transpose(item), do: item

  ## Common utilities

  @doc false
  def to_atom(value) when is_atom(value), do: value
  def to_atom(value) when is_binary(value), do: binary_to_atom(value)
  def to_atom(value), do: value

  @doc false
  def is_dict?(dict) do
    is_record(dict, Dict) || false
  end

  @doc false
  def get_clear_block([]), do: []
  def get_clear_block(block) do
    case block do
      {:__block__, _, block_list} -> block_list
      _ -> block
    end
  end

  @doc false
  def to_array(dict), do: to_array(dict, [])
  def to_array([], acc), do: acc
  def to_array([h|t], acc), do: to_array(t, acc ++ [[h]])

  @doc false
  def get_options(options) do
    if Dict.size(options) > 2 do
      Enum.at!(options, 2)
    else
      []
    end
  end

  @doc false
  def extract_options(params) do
    if Dict.size(params) > 1 do
      [Enum.at!(params, 0), Enum.at!(params, 1), get_options(params)]
    else
      [Enum.at!(params, 0), [],[]]
    end
  end

  @doc false
  def extract_do(block, position//0) do
    element = Enum.at!(block, position)
    if element[:do] != nil do
      element[:do]
    else
      element
    end
  end

  @doc false
  def key(dict) do
    Enum.first Dict.keys(dict)
  end

  @doc false
  def to_param([], acc), do: String.replace(acc, "&", "?", global: false)
  def to_param([h|t], acc) do
    {param, value} = h
    acc = acc <> "&#{param}=#{value}"
    to_param(t, acc)
  end
end