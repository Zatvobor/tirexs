defmodule Tirexs.DSL.Behaviour do
  @moduledoc false
  @note """
  Defines a main contract for domain specific handlers.
  """

  use Behaviour


  @doc """
  Receives a quoted dsl block and return a flat data structure which should be used to JSON encoding.
  """
  defcallback transpose(block :: list) :: list
end
