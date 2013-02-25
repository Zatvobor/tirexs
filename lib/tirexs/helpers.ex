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
end