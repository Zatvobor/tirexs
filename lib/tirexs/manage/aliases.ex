defmodule Tirexs.Manage.Aliases do
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
    [add: options]
  end

  def remove(options) do
    [remove: options]
  end

end