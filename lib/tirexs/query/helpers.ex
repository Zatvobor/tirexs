defmodule Tirexs.Query.Helpers do

  def get_clear_block([]) do
    []
  end


  def get_clear_block(block) do
    case block do
      {:__block__, _, block_list} -> block_list
      _ -> block
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
    scoped_query(get_clear_block(block), [])
  end

  defp scoped_query([], acc) do
    acc
  end

  defp scoped_query([h|t], acc) do
    scoped_query(get_clear_block(t), acc ++ cast_block(h))
  end

  defp scoped_query(item, acc) do
    acc ++ cast_block(item)
  end

  def extract_do(block, position//0) do
    Enum.at!(block, position)[:do]
  end


  defp cast_block(block) do
    # IO.puts inspect(block)
      case block do
        {:bool, _, [params]}      -> Tirexs.Query.Bool.bool(params[:do])
        {:must, _, [params]}      -> Tirexs.Query.Bool.must(params[:do])
        {:should, _, [params]}    -> Tirexs.Query.Bool.should(params[:do])
        {:must_not, _, [params]}  -> Tirexs.Query.Bool.must_not(params[:do])
        {:match, _, params}       -> Tirexs.Query.match(params)
        {:multi_match, _, params} -> Tirexs.Query.multi_match(params)
        {:range, _, params}       -> Tirexs.Query.range(params)
        {:boosting, _, [params]}  -> Tirexs.Query.boosting(params[:do])
        {:boosting, _, options}   -> Tirexs.Query.boosting(options)
        {:positive, _, params}    -> Tirexs.Query.Bootstring.positive(params)
        {:negative, _, params}    -> Tirexs.Query.Bootstring.negative(params)
        _ -> IO.puts inspect(block)
      end
  end

end