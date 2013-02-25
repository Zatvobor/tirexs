defmodule Tirexs.Query.Helpers do

  # import Bool

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

  def scoped_query(block) do
    Enum.map get_clear_block(block), fn(item) ->
      case item do
        {:bool, _, [params]} -> Tirexs.Query.Bool.bool(params[:do])
        {:must, _, [params]}  -> Tirexs.Query.Bool.must(params[:do])
        {:should, _, [params]} -> Tirexs.Query.Bool.should(params[:do])
        {:must_not, _, [params]} -> Tirexs.Query.Bool.must_not(params[:do])
        {:match, _, params} -> Tirexs.Query.match(params)
        {:multi_match, _, params} -> Tirexs.Query.multi_match(params)
        {:range, _, params} -> Tirexs.Query.range(params)
        _ -> IO.puts inspect(item)
      end
    end
  end

  def extract_array(bool_array) do
    extract_array(bool_array, [])
  end

  defp extract_array([], acc) do
    acc
  end

  defp extract_array([h|t], acc) do
    extract_array(t, acc ++ h)
  end

end