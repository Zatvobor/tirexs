defmodule Tirexs.Query do
  @moduledoc false

  import Tirexs.DSL.Logic
  import Tirexs.Query.Logic


  @doc false
  defmacro query([do: block]) do
    [query: extract(block)]
  end

  @doc false
  def _query(options, query_opts \\ [])

  @doc false
  def _query(options, _query_opts) when is_list(options) do
    query_opts = Enum.fetch!(options, 0)
    options = extract_do(options, 1)
    [query: extract(options) ++ query_opts]
  end

  @doc false
  def _query(options, query_opts) do
    [query: extract(options) ++ query_opts]
  end

  @doc false
  def match(options) do
    case options do
      [options] -> [match: extract(extract_do([options]))]
      _ ->
        [field, value, options] = extract_options(options)
        [match: Keyword.put([], to_atom(field), [query: value] ++ options)]
    end
  end

  @doc false
  def range(options) do
    [field, value, _] = extract_options(options)
    [range: Keyword.put([], to_atom(field), value)]
  end

  @doc false
  def multi_match(options) do
    [query, fields, options] = extract_options(options)
    [multi_match: [query: query, fields: fields] ++ options]
  end

  @doc false
  def match_phrase(options) do
    [field,value, _] = extract_options(options)
    [match_phrase: Keyword.put([], to_atom(field), value)]
  end

  @doc false
  def match_phrase_prefix(options) do
    [field,value, _] = extract_options(options)
    [match_phrase_prefix: Keyword.put([], to_atom(field), value)]
  end

  @doc false
  def function_score(options) do
    opts = extract_block(options[:do])
    [function_score: extract(opts)]
  end

  @doc false
  def field_value_factor(options) do
    opts = Enum.fetch!(options, 0)[:do]
    [field_value_factor: extract(opts)]
  end

  @doc false
  def modifier(param) do
    [modifier: Enum.fetch!(param, 0)]
  end

  @doc false
  def boost_mode(param) do
    [boost_mode: Enum.fetch!(param, 0)]
  end

  @doc false
  def max_boost(param) do
    [max_boost: Enum.fetch!(param, 0)]
  end

  @doc false
  def factor(param) do
    [factor: Enum.fetch!(param, 0)]
  end

  @doc false
  def min_score(param) do
    [min_score: Enum.fetch!(param, 0)]
  end

  @doc false
  def boosting(options, boosting_opts \\ [])

  @doc false
  def boosting(options, _boosting_opts) when is_list(options) do
    boosting_opts = Enum.fetch!(options, 0)
    options = extract_do(options, 1)
    [boosting: extract(options) ++ boosting_opts]
  end

  @doc false
  def boosting(options, boosting_opts) do
    [boosting: extract(options) ++ boosting_opts]
  end

  @doc false
  def ids(options) do
    [type, values, _] = extract_options(options)
    [ids: [type: type, values: values]]
  end

  @doc false
  def query_string(options) do
    [query, options, _] = extract_options(options)
    [query_string: [query: query] ++ options]
  end

  @doc false
  def custom_score(options, custom_score_opts \\ [])

  @doc false
  def custom_score(options, _custom_score_opts) when is_list(options) do
    customer_score_opts = extract_do(options, 1)
    options = Enum.fetch!(options, 0)
    [custom_score: extract(customer_score_opts) ++ options]
  end

  @doc false
  def custom_score(options, custom_score_opts) do
    [custom_score: extract(options) ++ custom_score_opts]
  end

  @doc false
  def custom_boost_factor(options, custom_boost_factor_opts \\ [])

  @doc false
  def custom_boost_factor(options, _custom_boost_factor_opts) when is_list(options) do
    customer_boost_factor_opts = extract_do(options, 1)
    options = Enum.fetch!(options, 0)
    [custom_boost_factor: extract(customer_boost_factor_opts) ++ options]
  end

  @doc false
  def custom_boost_factor(options, custom_boost_factor_opts) do
    [custom_boost_factor: extract(options) ++ custom_boost_factor_opts]
  end

  @doc false
  def constant_score(options, constant_score_opts \\ [])

  @doc false
  def constant_score(options, _constant_score_opts) when is_list(options) do
    constant_score_opts = extract_do(options, 1)
    options = Enum.fetch!(options, 0)
    [constant_score: extract(constant_score_opts) ++ options]
  end

  @doc false
  def constant_score(options, constant_score_opts) do
    [constant_score: extract(options) ++ constant_score_opts]
  end

  @doc false
  def dis_max(options, dis_max_opts \\ [])

  @doc false
  def dis_max(options, _dis_max_opts) when is_list(options) do
    dis_max_opts = extract_do(options, 1)
    options = Enum.fetch!(options, 0)
    [dis_max: extract(dis_max_opts) ++ options]
  end

  @doc false
  def dis_max(options, dis_max_opts) do
    [dis_max: extract(options) ++ dis_max_opts]
  end

  @doc false
  def term(options) do
    [field, values, options] = extract_options(options)
    [term: Keyword.put(options, to_atom(field), values)]
  end

  @doc false
  def field(options) do
    opts = case Enum.count(options) do
      1 -> Enum.fetch!(options, 0)
      _ ->
        [field, values, _] = extract_options(options)
        Keyword.put([], to_atom(field), values)
    end

    [field: opts]
  end

  @doc false
  def flt(options) do
    [value, fields, options] = extract_options(options)
    [fuzzy_like_this: [like_text: value, fields: fields] ++ options]
  end

  @doc false
  def flt_field(options) do
    [field, options, _] = extract_options(options)
    [fuzzy_like_this_field: Keyword.put([], to_atom(field), options)]
  end

  @doc false
  def fuzzy(options) do
    [field, values, _] = extract_options(options)
    [fuzzy: Keyword.put([], to_atom(field), values)]
  end

  @doc false
  def has_child(options, has_child_opts \\ [])

  @doc false
  def has_child(options, _has_child_opts) when is_list(options) do
    has_child_opts = extract_do(options, 1)
    options = Enum.fetch!(options, 0)
    [has_child: extract(has_child_opts) ++ options]
  end

  @doc false
  def has_child(options, has_child_opts) do
    [has_child: extract(options) ++ has_child_opts]
  end

  @doc false
  def has_parent(options, has_parent_opts \\ [])

  @doc false
  def has_parent(options, _has_parent_opts) when is_list(options) do
    has_parent_opts = extract_do(options, 1)
    options = Enum.fetch!(options, 0)
    [has_parent: extract(has_parent_opts) ++ options]
  end

  @doc false
  def has_parent(options, has_parent_opts) do
    [has_parent: extract(options) ++ has_parent_opts]
  end

  @doc false
  def match_all(options) do
    Keyword.put([], :match_all,  options)
  end

  @doc false
  def mlt(options) do
    [value, fields, options] = extract_options(options)
    [more_like_this: [like_text: value, fields: fields] ++ options]
  end

  @doc false
  def mlt_field(options) do
    [field, options, _] = extract_options(options)
    [more_like_this_field: Keyword.put([], to_atom(field), options)]
  end

  @doc false
  def prefix(options) do
    [field, values, _] = extract_options(options)
    [prefix: Keyword.put([], to_atom(field), values)]
  end

  @doc false
  def span_first(options, span_first_opts \\ [])

  @doc false
  def span_first(options, _span_first_opts) when is_list(options) do
    span_first_opts = extract_do(options, 1)
    options = Enum.fetch!(options, 0)
    [span_first: extract(span_first_opts) ++ options]
  end

  @doc false
  def span_first(options, span_first_opts) do
    [span_first: extract(options) ++ span_first_opts]
  end

  @doc false
  def span_term(options) do
    [field, options, _] = extract_options(options)
    [span_term: Keyword.put([], to_atom(field), options)]
  end

  @doc false
  def span_near(options, span_near_opts \\ [])

  @doc false
  def span_near(options, _span_near_opts) when is_list(options) do
    [span_near: extract(extract_do(options, 1)) ++ Enum.fetch!(options, 0)]
  end

  @doc false
  def span_near(options, span_near_opts) do
    [span_near: extract(options) ++ span_near_opts]
  end

  @doc false
  def span_not(options, span_not_opts \\ [])

  @doc false
  def span_not(options, _span_not_opts) when is_list(options) do
    [span_not: extract(extract_do(options, 1)) ++ Enum.fetch!(options, 0)]
  end

  @doc false
  def span_not(options, span_not_opts) do
    [span_not: extract(options) ++ span_not_opts]
  end

  @doc false
  def span_or(options, span_or_opts \\ [])

  @doc false
  def span_or(options, _span_or_opts) when is_list(options) do
    span_or_opts = extract_do(options, 1)
    options = Enum.fetch!(options, 0)
    [span_or: extract(span_or_opts) ++ options]
  end

  @doc false
  def span_or(options, span_or_opts) do
    [span_or: extract(options) ++ span_or_opts]
  end

  @doc false
  def span_multi(options) do
    [span_multi: extract(options)]
  end

  @doc false
  def terms(options) do
    [field, value, options] = extract_options(options)
    [terms: Keyword.put([], to_atom(field), value) ++ options]
  end

  @doc false
  def top_children(options, top_children_opts \\ [])

  @doc false
  def top_children(options, _top_children_opts) when is_list(options) do
    top_children_opts = extract_do(options, 1)
    options = Enum.fetch!(options, 0)
    [top_children: extract(top_children_opts) ++ options]
  end

  @doc false
  def top_children(options, top_children_opts) do
    [top_children: extract(options) ++ top_children_opts]
  end

  @doc false
  def wildcard(options) do
    [field, options, _] = extract_options(options)
    [wildcard: Keyword.put([], to_atom(field), options)]
  end

  @doc false
  def indices(options, indices_opts \\ [])

  @doc false
  def indices(options, _indices_opts) when is_list(options) do
    indices_opts = extract_do(options, 1)
    options = Enum.fetch!(options, 0)
    [indices: extract(indices_opts) ++ options]
  end

  @doc false
  def indices(options, indices_opts) do
    [indices: extract(options) ++ indices_opts]
  end

  @doc false
  def text(options) do
    [field, values, _] = extract_options(options)
    [text: Keyword.put([], to_atom(field), values)]
  end

  @doc false
  def geo_shape(options, geo_shape_opts \\ [])

  @doc false
  def geo_shape(options, _geo_shape_opts) when is_list(options) do
    geo_shape_opts = extract_do(options, 1)
    options = Enum.fetch!(options, 0)
    [geo_shape: extract(geo_shape_opts) ++ options]
  end

  @doc false
  def geo_shape(options, geo_shape_opts) do
    [geo_shape: extract(options) ++ geo_shape_opts]
  end

  @doc false
  def nested(options, nested_opts \\ [])

  @doc false
  def nested(options, _nested_opts) when is_list(options) do
    nested_opts = extract_do(options, 1)
    options = Enum.fetch!(options, 0)
    [nested: extract(nested_opts) ++ options]
  end

  @doc false
  def nested(options, nested_opts) do
    [nested: extract(options) ++ nested_opts]
  end

  @doc false
  def rescore_query(options, rescore_opts \\ [])

  @doc false
  def rescore_query(options, _rescore_opts) when is_list(options) do
    rescore_opts = extract_do(options, 1)
    options = Enum.fetch!(options, 0)
    [rescore_query: extract(rescore_opts) ++ options]
  end

  @doc false
  def rescore_query(options, rescore_opts) do
    [rescore_query: extract(options) ++ rescore_opts]
  end

  @doc false
  def facet_filter(options, facet_opts \\ [])

  @doc false
  def facet_filter(options, _facet_opts) when is_list(options) do
    facet_opts = extract_do(options, 1)
    options = Enum.fetch!(options, 0)
    [facet_filter: extract(facet_opts) ++ options]
  end

  @doc false
  def facet_filter(options, facet_opts) do
    [facet_filter: extract(options) ++ facet_opts]
  end

  @doc false
  def custom_filters_score(options, custom_filters_score_opts \\ [])

  @doc false
  def custom_filters_score(options, _custom_filters_score_opts) when is_list(options) do
    custom_filters_score_opts = Enum.fetch!(options, 0)
    options = extract_do(options, 1)

    custom_filters_score = extract(options) ++ custom_filters_score_opts
    query = [query: custom_filters_score[:query]]
    filters = custom_filters_score[:filters]
    query = Keyword.put(query, :filters, without_array(filters, []))

    [custom_filters_score: query ++ custom_filters_score_opts]
  end

  @doc false
  def custom_filters_score(options, custom_filters_score_opts) do
    custom_filters_score = extract(options) ++ custom_filters_score_opts
    query = [query: custom_filters_score[:query]]
    filters = custom_filters_score[:filters]
    query = Keyword.put(query, :filters, without_array(filters, []))

    [custom_filters_score: query ++ custom_filters_score_opts]
  end

  @doc false
  def boost(options) do
    [value, _, _] = extract_options(options)
    [boost: value]
  end

  @doc false
  def group(options, _object_opts \\ [])

  @doc false
  def group(options, _object_opts) when is_list(options) do
    [extract(extract_do(options, 1))]
  end

  @doc false
  def group(options, _object_opts) do
    [extract(options)]
  end

  @doc false
  def bool(options, bool_opts \\ [])

  @doc false
  def bool(options, _bool_opts) when is_list(options) do
    bool_opts = extract_do(options, 1)
    options = Enum.fetch!(options, 0)
    [bool: extract(bool_opts) ++ options]
  end

  @doc false
  def bool(options, bool_opts) do
    [bool: extract(options) ++ bool_opts]
  end

  @doc false
  def must(block) do
    [must: to_array(extract(block))]
  end

  @doc false
  def should(block) do
    [should: to_array(extract(block))]
  end

  @doc false
  def must_not(block) do
    [must_not: to_array(extract(block))]
  end

  @doc false
  def positive(options) do
    [positive: extract(extract_do(options))]
  end

  @doc false
  def negative(options) do
    [negative: extract(extract_do(options))]
  end

  @doc false
  def queries(options) do
    [queries: to_array(extract(options))]
  end

  @doc false
  def location(options, location_opts \\ [])

  @doc false
  def location(options, _location_opts) when is_list(options) do
    location_opts = extract_do(options, 1)
    options = Enum.fetch!(options, 0)
    [location: extract(location_opts) ++ options]
  end

  @doc false
  def location(options, location_opts) do
    [location: extract(options) ++ location_opts]
  end

  @doc false
  def shape(options) do
    [shape: options]
  end

  @doc false
  def indexed_shape(options) do
    [indexed_shape: options]
  end

  @doc false
  def no_match_query(options) when is_binary(options) do
    [no_match_query: options]
  end

  @doc false
  def no_match_query(options) do
    [no_match_query: extract(options)]
  end

  @doc false
  def clauses(options) do
    [clauses: to_array(extract(options))]
  end

  @doc false
  def include(options) do
    [include: extract(options[:do])]
  end

  @doc false
  def exclude(options) do
    [exclude: extract(options[:do])]
  end

  @doc false
  def text_phrase(options) do
    [field, values, _] = extract_options(options)
    [text_phrase: Keyword.put([], to_atom(field), values)]
  end

  @doc false
  def text_phrase_prefix(options) do
    [field, values, _] = extract_options(options)
    [text_phrase_prefix: Keyword.put([], to_atom(field), values)]
  end

  @doc false
  def create_resource(definition, params) when is_list(params) do
    create_resource(definition, Tirexs.get_uri_env(), params)
  end

  @doc false
  def create_resource(definition, %URI{} = uri \\ Tirexs.get_uri_env(), params \\ []) do
    urn = if definition[:type] do
      "#{definition[:index]}/#{definition[:type]}"
    else
      "#{definition[:index]}"
    end
    search = definition[:search]
    Tirexs.bump(search, uri)._search(urn, {params})
  end
end
