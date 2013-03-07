defmodule Tirexs.Manage do
  import Tirexs.Helpers

  defmacro aliases([do: block]) do
    actions = get_clear_block(block)
    if is_tuple(actions) do
      [actions: [actions]]
    else
      [actions: actions]
    end
  end

  def add(options) do
    unless options[:filter] == nil do
      options = Dict.put(options, :filter, options[:filter][:filter])
    end
    [add: options]
  end

  def remove(options) do
    [remove: options]
  end

end