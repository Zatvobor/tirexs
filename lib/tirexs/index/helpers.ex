defmodule Tirexs.Index.Helpers do

  import Tirexs.DSL.Logic

  def put_setting(index, type) do
    settings = index[:settings]
    settings = Dict.put(settings, type, [])
    Dict.put(index, :settings, settings)
  end

  def put_index_setting(index, main_type, type) do
    index_settings = index[:settings][main_type]
    index_settings = Dict.put(index_settings, type, [])
    settings = Dict.put(index[:settings], main_type, index_settings)
    Dict.put(index, :settings, settings)
  end

  def add_index_setting(index, value) do
    index_settings = index[:settings][:index]
    settings = Dict.put(index[:settings], :index, index_settings ++ value)
    Dict.put(index, :settings, settings)
  end

  def add_index_setting(index, main_type, type, value) do
    main_index_settings = index[:settings][main_type]
    type_settings = index[:settings][main_type][type]
    main_index_settings = Dict.put(main_index_settings, type, type_settings ++ value)
    settings = Dict.put(index[:settings], main_type, main_index_settings)
    Dict.put(index, :settings, settings)
  end

  def add_index_setting_nested_type(index, main_type, type, nested_type, value) do
    main_index_settings = index[:settings][main_type]
    type_settings = index[:settings][main_type][type]
    type_with_nested_type_settings = type_settings[nested_type]
    type_settings = Dict.put(type_settings, nested_type, type_with_nested_type_settings ++ value)
    main_index_settings = Dict.put(main_index_settings, type, type_settings)
    settings = Dict.put(index[:settings], main_type, main_index_settings)
    Dict.put(index, :settings, settings)
  end

end