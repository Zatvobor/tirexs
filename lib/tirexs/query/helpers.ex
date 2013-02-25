defmodule Tirexs.Query.Helpers do

  def get_clear_block(block) do
    case block do
      {:__block__, _, block_list} -> block_list
      _ -> [block]
    end
  end

  def get_options(options) do
    if Dict.size(options) > 2 do
      Enum.at!(options, 2)
    else
      []
    end
  end

  def extract_options(params) do
    [Enum.at!(params, 0), Enum.at!(params, 1), get_options(params)]
  end

end