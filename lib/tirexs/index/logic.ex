defmodule Tirexs.Index.Logic do
  @moduledoc false


  @doc false
  def put_setting(index, type) do
    update_in(index[:settings][type], fn
      nil -> []
      settings -> settings
    end)
  end

  @doc false
  def put_index_setting(index, main_type, type) do
    update_in(index[:settings][main_type][type], fn
      nil -> []
      settings -> settings
    end)
  end

  @doc false
  def put_index_setting_nested_type(index, main_type, type, nested_type) do
    update_in(index[:settings][main_type][type][nested_type], fn
      nil -> []
      settings -> settings
    end)
  end

  @doc false
  def add_index_setting(index, value) do
    update_in(index[:settings][:index], &(&1 ++ value))
  end

  @doc false
  def add_index_setting(index, main_type, type, value) do
    update_in(index[:settings][main_type][type], &(&1 ++ value))
  end

  @doc false
  def add_index_setting_nested_type(index, main_type, type, nested_type, value) do
    update_in(index[:settings][main_type][type][nested_type], &(&1 ++ value))
  end
end
