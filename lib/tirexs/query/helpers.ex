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
    if Dict.size(params) > 1 do
      [Enum.at!(params, 0), Enum.at!(params, 1), get_options(params)]
    else
      [Enum.at!(params, 0), [],[]]
    end
  end

  def scoped_query(block) do
    scoped_query(get_clear_block(block), [])
  end

  defp scoped_query([], acc) do
    acc
  end

  defp scoped_query([h|t], acc) do
    scoped_query(get_clear_block(t), acc ++ routers(h))
  end

  defp scoped_query(item, acc) do
    acc ++ routers(item)
  end

  def extract_do(block, position//0) do
    Enum.at!(block, position)[:do]
  end


  defp routers(block) do
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
        {:filter, _, [params]}              -> Tirexs.Filter._filter(params[:do])
        {:filter, _, options}               -> Tirexs.Filter._filter(options)
        {:filtered, _, [params]}            -> Tirexs.Filter.filtered(params[:do])
        {:has_child, _, [params]}           -> Tirexs.Query.has_child(params[:do])
        {:has_child, _, options}            -> Tirexs.Query.has_child(options)
        {:has_parent, _, [params]}          -> Tirexs.Query.has_parent(params[:do])
        {:has_parent, _, options}           -> Tirexs.Query.has_parent(options)
        {:match_all, _, nil}                -> Tirexs.Query.match_all([])
        {:match_all, _, [params]}           -> Tirexs.Query.match_all(params)
        {:mlt, _, params}                   -> Tirexs.Query.mlt(params)
        {:mlt_field, _, params}             -> Tirexs.Query.mlt_field(params)
        {:prefix, _, params}                -> Tirexs.Query.prefix(params)
        {:span_first, _, [params]}          -> Tirexs.Query.span_first(params[:do])
        {:span_first, _, options}           -> Tirexs.Query.span_first(options)
        {:span_term, _, params}             -> Tirexs.Query.span_term(params)
        {:span_near, _, [params]}           -> Tirexs.Query.span_near(params)
        {:span_near, _, options}            -> Tirexs.Query.span_near(options)
        {:clauses, _, [params]}             -> Tirexs.Query.SpanNear.clauses(params[:do])
        {:span_not, _, [params]}            -> Tirexs.Query.span_not(params[:do])
        {:span_not, _, options}             -> Tirexs.Query.span_not(options)
        {:include, _, [params]}             -> Tirexs.Query.SpanNot.include(params)
        {:exclude, _, [params]}             -> Tirexs.Query.SpanNot.exclude(params)
        {:span_or, _, [params]}             -> Tirexs.Query.span_or(params[:do])
        {:span_or, _, options}              -> Tirexs.Query.span_or(options)
        {:terms, _, params}                 -> Tirexs.Query.terms(params)
        {:top_children, _, [params]}        -> Tirexs.Query.top_children(params)
        {:top_children, _, options}         -> Tirexs.Query.top_children(options)
        {:wildcard, _, params}              -> Tirexs.Query.wildcard(params)
        {:no_match_query, _, [params]}      -> Tirexs.Query.Indeces.no_match_query(params[:do])
        {:indices, _, [params]}             -> Tirexs.Query.indices(params[:do])
        {:indices, _, params}               -> Tirexs.Query.indices(params)
        {:text, _, params}                  -> Tirexs.Query.text(params)
        {:text_phrase, _, params}           -> Tirexs.Query.Text.text_phrase(params)
        {:text_phrase_prefix, _, params}    -> Tirexs.Query.Text.text_phrase_prefix(params)
        {:geo_shape, _, [params]}           -> Tirexs.Query.geo_shape(params[:do])
        {:geo_shape, _, options}            -> Tirexs.Query.geo_shape(options)
        {:location, _, [params]}            -> Tirexs.Query.GeoShare.location(params[:do])
        {:location, _, options}             -> Tirexs.Query.GeoShare.location(options)
        {:shape, _, [params]}               -> Tirexs.Query.GeoShare.shape(params)
        {:indexed_shape, _, [params]}       -> Tirexs.Query.GeoShare.indexed_shape(params)
        {:exists, _, params}                -> Tirexs.Filter.exists(params)
        {:limit, _, params}                 -> Tirexs.Filter.limit(params)
        {:type, _, params}                  -> Tirexs.Filter.type(params)
        {:missing, _, params}               -> Tirexs.Filter.missing(params)
        {:geo_bounding_box, _, params}      -> Tirexs.Filter.Geo.geo_bounding_box(params)
        {:geo_distance, _, params}          -> Tirexs.Filter.Geo.geo_distance(params)
        {:geo_distance_range, _, params}    -> Tirexs.Filter.Geo.geo_distance_range(params)
        {:geo_polygon, _, params}           -> Tirexs.Filter.Geo.geo_polygon(params)
        {:_not, _, [params]}                -> Tirexs.Filter._not(params[:do])
        {:_not, _, options}                 -> Tirexs.Filter._not(options)

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