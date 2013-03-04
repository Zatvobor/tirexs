defmodule Tirexs.Filter.Methods do

  import Tirexs.Helpers

  def join(:and, filters) do
    [and: [filters: to_array(filters)]]
  end

  def join(:or, filters) do
    [or: [filters: to_array(filters)]]
  end
end