defmodule Tirexs.Filter.Methods do

  import Tirexs.DSL.Logic

  def join(:and, filters) do
    [and: [filters: to_array(filters)]]
  end

  def join(:or, filters) do
    [or: [filters: to_array(filters)]]
  end
end