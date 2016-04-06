defmodule Tirexs.Index.Logic do
  @moduledoc false


  @doc false
  def put_setting(index, type) do
    settings = index[:settings]
    settings = Keyword.put(settings, type, [])
    Keyword.put(index, :settings, settings)
  end

  @doc false
  def put_index_setting(index, main_type, type) do
    index_settings = index[:settings][main_type]
    index_settings = Keyword.put(index_settings, type, [])

    pass_settings(index, main_type, index_settings)
  end

  @doc false
  def add_index_setting(index, value) do
    index_settings = index[:settings][:index]

    pass_settings(index, :index, index_settings ++ value)
  end

  @doc false
  def add_index_setting(index, main_type, type, value) do
    main_index_settings = index[:settings][main_type]
    type_settings       = index[:settings][main_type][type]
    main_index_settings = Keyword.put(main_index_settings, type, type_settings ++ value)

    pass_settings(index, main_type, main_index_settings)
  end

  @doc false
  def add_index_setting_nested_type(index, main_type, type, nested_type, value) do
    main_index_settings = index[:settings][main_type]
    type_settings       = index[:settings][main_type][type]
    type_with_nested_type_settings = type_settings[nested_type]
    type_settings       = Keyword.put(type_settings, nested_type, type_with_nested_type_settings ++ value)
    main_index_settings = Keyword.put(main_index_settings, type, type_settings)

    pass_settings(index, main_type, main_index_settings)
  end


  defp pass_settings(index, type, settings) do
    Keyword.put(index, :settings, Keyword.put(index[:settings], type, settings))
  end
end
