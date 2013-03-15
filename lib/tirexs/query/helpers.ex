defmodule Tirexs.Query.Helpers do
  @moduledoc false

  use Tirexs.DSL.Logic


  def transpose(block) do
      case block do
        {:bool, _, [params]}                  -> Tirexs.Query.Bool.bool(params[:do])
        {:must, _, [params]}                  -> Tirexs.Query.Bool.must(params[:do])
        {:filters, _, [params]}               -> Tirexs.Filter.filters(params[:do])
        {:should, _, [params]}                -> Tirexs.Query.Bool.should(params[:do])
        {:must_not, _, [params]}              -> Tirexs.Query.Bool.must_not(params[:do])
        {:match, _, params}                   -> Tirexs.Query.match(params)
        {:multi_match, _, params}             -> Tirexs.Query.multi_match(params)
        {:query_string, _, params}            -> Tirexs.Query.query_string(params)
        {:ids, _, params}                     -> Tirexs.Query.ids(params)
        {:range, _, params}                   -> Tirexs.Query.range(params)
        {:term, _, params}                    -> Tirexs.Query.term(params)
        {:boosting, _, [params]}              -> Tirexs.Query.boosting(params[:do])
        {:boosting, _, options}               -> Tirexs.Query.boosting(options)
        {:positive, _, params}                -> Tirexs.Query.Bootstring.positive(params)
        {:negative, _, params}                -> Tirexs.Query.Bootstring.negative(params)
        {:custom_score, _, [params]}          -> Tirexs.Query.custom_score(params[:do])
        {:custom_score, _, options}           -> Tirexs.Query.custom_score(options)
        {:custom_boost_factor, _, [params]}   -> Tirexs.Query.custom_boost_factor(params[:do])
        {:custom_boost_factor, _, options}    -> Tirexs.Query.custom_boost_factor(options)
        {:constant_score, _, [params]}        -> Tirexs.Query.constant_score(params[:do])
        {:constant_score, _, options}         -> Tirexs.Query.constant_score(options)
        {:dis_max, _, [params]}               -> Tirexs.Query.dis_max(params[:do])
        {:dis_max, _, options}                -> Tirexs.Query.dis_max(options)
        {:queries, _, [params]}               -> Tirexs.Query.DisMax.queries(params[:do])
        {:field, _, params}                   -> Tirexs.Query.field(params)
        {:flt, _, params}                     -> Tirexs.Query.flt(params)
        {:flt_field, _, params}               -> Tirexs.Query.flt_field(params)
        {:fuzzy, _, params}                   -> Tirexs.Query.fuzzy(params)
        {:query, _, [params]}                 -> Tirexs.Query._query(params[:do])
        {:filter, _, [params]}                -> Tirexs.Filter._filter(params[:do])
        {:filter, _, options}                 -> Tirexs.Filter._filter(options)
        {:filtered, _, [params]}              -> Tirexs.Filter.filtered(params[:do])
        {:has_child, _, [params]}             -> Tirexs.Query.has_child(params[:do])
        {:has_child, _, options}              -> Tirexs.Query.has_child(options)
        {:has_parent, _, [params]}            -> Tirexs.Query.has_parent(params[:do])
        {:has_parent, _, options}             -> Tirexs.Query.has_parent(options)
        {:match_all, _, nil}                  -> Tirexs.Query.match_all([])
        {:match_all, _, [params]}             -> Tirexs.Query.match_all(params)
        {:mlt, _, params}                     -> Tirexs.Query.mlt(params)
        {:mlt_field, _, params}               -> Tirexs.Query.mlt_field(params)
        {:prefix, _, params}                  -> Tirexs.Query.prefix(params)
        {:span_first, _, [params]}            -> Tirexs.Query.span_first(params[:do])
        {:span_first, _, options}             -> Tirexs.Query.span_first(options)
        {:span_term, _, params}               -> Tirexs.Query.span_term(params)
        {:span_near, _, [params]}             -> Tirexs.Query.span_near(params)
        {:span_near, _, options}              -> Tirexs.Query.span_near(options)
        {:clauses, _, [params]}               -> Tirexs.Query.SpanNear.clauses(params[:do])
        {:span_not, _, [params]}              -> Tirexs.Query.span_not(params[:do])
        {:span_not, _, options}               -> Tirexs.Query.span_not(options)
        {:include, _, [params]}               -> Tirexs.Query.SpanNot.include(params)
        {:exclude, _, [params]}               -> Tirexs.Query.SpanNot.exclude(params)
        {:span_or, _, [params]}               -> Tirexs.Query.span_or(params[:do])
        {:span_or, _, options}                -> Tirexs.Query.span_or(options)
        {:terms, _, params}                   -> Tirexs.Query.terms(params)
        {:top_children, _, [params]}          -> Tirexs.Query.top_children(params)
        {:top_children, _, options}           -> Tirexs.Query.top_children(options)
        {:wildcard, _, params}                -> Tirexs.Query.wildcard(params)
        {:no_match_query, _, [params]}        -> Tirexs.Query.Indices.no_match_query(params[:do])
        {:indices, _, [params]}               -> Tirexs.Query.indices(params[:do])
        {:indices, _, params}                 -> Tirexs.Query.indices(params)
        {:text, _, params}                    -> Tirexs.Query.text(params)
        {:text_phrase, _, params}             -> Tirexs.Query.Text.text_phrase(params)
        {:text_phrase_prefix, _, params}      -> Tirexs.Query.Text.text_phrase_prefix(params)
        {:geo_shape, _, [params]}             -> Tirexs.Query.geo_shape(params[:do])
        {:geo_shape, _, options}              -> Tirexs.Query.geo_shape(options)
        {:location, _, [params]}              -> Tirexs.Query.GeoShare.location(params[:do])
        {:location, _, options}               -> Tirexs.Query.GeoShare.location(options)
        {:shape, _, [params]}                 -> Tirexs.Query.GeoShare.shape(params)
        {:indexed_shape, _, [params]}         -> Tirexs.Query.GeoShare.indexed_shape(params)
        {:exists, _, params}                  -> Tirexs.Filter.exists(params)
        {:limit, _, params}                   -> Tirexs.Filter.limit(params)
        {:type, _, params}                    -> Tirexs.Filter.type(params)
        {:missing, _, params}                 -> Tirexs.Filter.missing(params)
        {:geo_bounding_box, _, params}        -> Tirexs.Filter.Geo.geo_bounding_box(params)
        {:geo_distance, _, params}            -> Tirexs.Filter.Geo.geo_distance(params)
        {:geo_distance_range, _, params}      -> Tirexs.Filter.Geo.geo_distance_range(params)
        {:geo_polygon, _, params}             -> Tirexs.Filter.Geo.geo_polygon(params)
        {:_not, _, [params]}                  -> Tirexs.Filter._not(params[:do])
        {:_not, _, options}                   -> Tirexs.Filter._not(options)
        {:_and, _, [params]}                  -> Tirexs.Filter._and(params[:do])
        {:_and, _, options}                   -> Tirexs.Filter._and(options)
        {:_or, _, [params]}                   -> Tirexs.Filter._or(params[:do])
        {:_or, _, options}                    -> Tirexs.Filter._or(options)
        {:numeric_range, _, params}           -> Tirexs.Filter.numeric_range(params)
        {:fquery, _, [params]}                -> Tirexs.Filter.fquery(params[:do])
        {:fquery, _, options}                 -> Tirexs.Filter.fquery(options)
        {:script, _, params}                  -> Tirexs.Filter.script(params)
        {:nested, _, [params]}                -> Tirexs.Query.nested(params[:do])
        {:nested, _, options}                 -> Tirexs.Query.nested(options)
        {:rescore_query, _, [params]}         -> Tirexs.Query.rescore_query(params[:do])
        {:rescore_query, _, options}          -> Tirexs.Query.rescore_query(options)
        {:facet_filter, _, [params]}          -> Tirexs.Query.facet_filter(params[:do])
        {:facet_filter, _, options}           -> Tirexs.Query.facet_filter(options)
        {:custom_filters_score, _, [params]}  -> Tirexs.Query.custom_filters_score(params[:do])
        {:custom_filters_score, _, options}   -> Tirexs.Query.custom_filters_score(options)
        {:boost, _, params}                   -> Tirexs.Query.boost(params)
        {:group, _, [params]}                 -> Tirexs.Query.group(params[:do])
        {:group, _, options}                  -> Tirexs.Query.group(options)

        _ -> IO.puts inspect(block)
      end
  end


  def without_array([], acc) do
    acc
  end

  def without_array([h|t], acc) do
    acc = acc ++ [Enum.first h]
    without_array(t, acc)
  end

  def without_array(_array, acc) do
    acc
  end
end