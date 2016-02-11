defmodule Tirexs.Manage.Aliases do
  @moduledoc false

  import Tirexs.DSL.Logic


  @doc false
  defmacro aliases([do: block]) do
    actions = extract_block(block)
    if is_tuple(actions) do
      [actions: [actions]]
    else
      [actions: actions]
    end
  end


  @doc false
  def add(options), do: [add: options]

  @doc false
  def remove(options), do: [remove: options]
end
