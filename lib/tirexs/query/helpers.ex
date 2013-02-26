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
      case block do
        {:bool, _, [params]}                -> Tirexs.Query.Bool.bool(params[:do])
        {:must, _, [params]}                -> Tirexs.Query.Bool.must(params[:do])
        {:should, _, [params]}              -> Tirexs.Query.Bool.should(params[:do])
        {:must_not, _, [params]}            -> Tirexs.Query.Bool.must_not(params[:do])
        {:match, _, params}                 -> Tirexs.Query.match(params)
        {:multi_match, _, params}           -> Tirexs.Query.multi_match(params)
        {:query_string, _, params}          -> Tirexs.Query.query_string(params)
        {:ids, _, params}                   -> Tirexs.Query.ids(params)
        {:range, _, params}                 -> Tirexs.Query.range(params)
        {:term, _, params}                  -> Tirexs.Query.term(params)
        {:boosting, _, [params]}            -> Tirexs.Query.boosting(params[:do])
        {:boosting, _, options}             -> Tirexs.Query.boosting(options)
        {:positive, _, params}              -> Tirexs.Query.Bootstring.positive(params)
        {:negative, _, params}              -> Tirexs.Query.Bootstring.negative(params)
        {:custom_score, _, [params]}        -> Tirexs.Query.custom_score(params[:do])
        {:custom_score, _, options}         -> Tirexs.Query.custom_score(options)
        {:custom_boost_factor, _, [params]} -> Tirexs.Query.custom_boost_factor(params[:do])
        {:custom_boost_factor, _, options}  -> Tirexs.Query.custom_boost_factor(options)
        {:constant_score, _, [params]}      -> Tirexs.Query.constant_score(params[:do])
        {:constant_score, _, options}       -> Tirexs.Query.constant_score(options)
        {:dis_max, _, [params]}             -> Tirexs.Query.dis_max(params[:do])
        {:dis_max, _, options}              -> Tirexs.Query.dis_max(options)
        {:queries, _, [params]}             -> Tirexs.Query.DisMax.queries(params[:do])
        {:field, _, params}                 -> Tirexs.Query.field(params)
        {:flt, _, params}                   -> Tirexs.Query.flt(params)
        {:flt_field, _, params}             -> Tirexs.Query.flt_field(params)
        {:fuzzy, _, params}                 -> Tirexs.Query.fuzzy(params)
        {:query, _, [params]}               -> Tirexs.Query._query(params[:do])
        {:has_child, _, [params]}           -> Tirexs.Query.has_child(params[:do])
        {:has_child, _, options}            -> Tirexs.Query.has_child(options)
        {:has_parent, _, [params]}          -> Tirexs.Query.has_parent(params[:do])
        {:has_parent, _, options}           -> Tirexs.Query.has_parent(options)
        {:match_all, _, nil}                -> Tirexs.Query.match_all([])
        {:match_all, _, [params]}             -> Tirexs.Query.match_all(params)
        _ -> IO.puts inspect(block)
      end
  end


  def to_array(dict) do
    to_array(dict, [])
  end

  def to_array([], acc) do
    acc
  end

  def to_array([h|t], acc) do
    to_array(t, acc ++ [[h]])
  end

end