defmodule Tirexs.Query do
  @moduledoc false

  require Record

  import Tirexs.DSL.Logic
  import Tirexs.Query.Logic

  Record.defrecord :result, [count: 0, max_score: nil, facets: [], aggregations: [], hits: [], _scroll_id: nil]


  @doc false
  defmacro query([do: block]) do
    [query: extract(block)]
  end

  @doc false
  def _query(options, query_opts\\[]) do
    if is_list(options) do
      query_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
    [query: extract(options) ++ query_opts]
  end

  @doc false
  def match(options) do
    case options do
      [options] -> [match: extract(extract_do([options]))]
      _ ->
        [field, value, options] = extract_options(options)
        [match: Dict.put([], to_atom(field), [query: value] ++ options)]
    end
  end

  @doc false
  def range(options) do
    [field, value, _] = extract_options(options)
    [range: Dict.put([], to_atom(field), value)]
  end

  @doc false
  def multi_match(options) do
    [query, fields, _] = extract_options(options)
    [multi_match: [query: query, fields: fields]]
  end

  @doc false
  def boosting(options, boosting_opts\\[]) do
    if is_list(options) do
      boosting_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
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
  def custom_score(options, custom_score_opts\\[]) do
    if is_list(options) do
      custom_score_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
    [custom_score: extract(options) ++ custom_score_opts]
  end

  @doc false
  def custom_boost_factor(options, custom_boost_factor_opts\\[]) do
    if is_list(options) do
      custom_boost_factor_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
    [custom_boost_factor: extract(options) ++ custom_boost_factor_opts]
  end

  @doc false
  def constant_score(options, constant_score_opts\\[]) do
    if is_list(options) do
      constant_score_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
    [constant_score: extract(options) ++ constant_score_opts]
  end

  @doc false
  def dis_max(options, dis_max_opts\\[]) do
    if is_list(options) do
      dis_max_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
    [dis_max: extract(options) ++ dis_max_opts]
  end

  @doc false
  def term(options) do
    [field, values, options] = extract_options(options)
    [term: Dict.put(options, to_atom(field), values)]
  end

  @doc false
  def field(options) do
    [field, values, _] = extract_options(options)
    [field: Dict.put([], to_atom(field), values)]
  end

  @doc false
  def flt(options) do
    [value, fields, options] = extract_options(options)
    [fuzzy_like_this: [like_text: value, fields: fields] ++ options]
  end

  @doc false
  def flt_field(options) do
    [field, options, _] = extract_options(options)
    [fuzzy_like_this_field: Dict.put([], to_atom(field), options)]
  end

  @doc false
  def fuzzy(options) do
    [field, values, _] = extract_options(options)
    [fuzzy: Dict.put([], to_atom(field), values)]
  end

  @doc false
  def has_child(options, has_child_opts\\[]) do
    if is_list(options) do
      has_child_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
    [has_child: extract(options) ++ has_child_opts]
  end

  @doc false
  def has_parent(options, has_parent_opts\\[]) do
    if is_list(options) do
      has_parent_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
    [has_parent: extract(options) ++ has_parent_opts]
  end

  @doc false
  def match_all(options) do
    Dict.put([], :match_all,  options)
  end

  @doc false
  def mlt(options) do
    [value, fields, options] = extract_options(options)
    [more_like_this: [like_text: value, fields: fields] ++ options]
  end

  @doc false
  def mlt_field(options) do
    [field, options, _] = extract_options(options)
    [more_like_this_field: Dict.put([], to_atom(field), options)]
  end

  @doc false
  def prefix(options) do
    [field, values, _] = extract_options(options)
    [prefix: Dict.put([], to_atom(field), values)]
  end

  @doc false
  def span_first(options, span_first_opts\\[]) do
    if is_list(options) do
      span_first_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
    [span_first: extract(options) ++ span_first_opts]
  end

  @doc false
  def span_term(options) do
    [field, options, _] = extract_options(options)
    [span_term: Dict.put([], to_atom(field), options)]
  end

  @doc false
  def span_near(options, span_near_opts\\[]) do
    if is_list(options) do
      span_near_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
    [span_near: extract(options) ++ span_near_opts]
  end

  @doc false
  def span_not(options, span_not_opts\\[]) do
    if is_list(options) do
      span_not_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
    [span_not: extract(options) ++ span_not_opts]
  end

  @doc false
  def span_or(options, span_or_opts\\[]) do
    if is_list(options) do
      span_or_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
    [span_or: extract(options) ++ span_or_opts]
  end

  @doc false
  def terms(options) do
    [field, value, options] = extract_options(options)
    [terms: Dict.put([], to_atom(field), value) ++ options]
  end

  @doc false
  def top_children(options, top_children_opts\\[]) do
    if is_list(options) do
      top_children_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
    [top_children: extract(options) ++ top_children_opts]
  end

  @doc false
  def wildcard(options) do
    [field, options, _] = extract_options(options)
    [wildcard: Dict.put([], to_atom(field), options)]
  end

  @doc false
  def indices(options, indices_opts\\[]) do
    if is_list(options) do
      indices_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
    [indices: extract(options) ++ indices_opts]
  end

  @doc false
  def text(options) do
    [field, values, _] = extract_options(options)
    [text: Dict.put([], to_atom(field), values)]
  end

  @doc false
  def geo_shape(options, geo_shape_opts\\[]) do
    if is_list(options) do
      geo_shape_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
    [geo_shape: extract(options) ++ geo_shape_opts]
  end

  @doc false
  def nested(options, nested_opts\\[]) do
    if is_list(options) do
      nested_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
    [nested: extract(options) ++ nested_opts]
  end

  @doc false
  def rescore_query(options, rescore_opts\\[]) do
    if is_list(options) do
      rescore_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
    [rescore_query: extract(options) ++ rescore_opts]
  end

  @doc """
  WARNING: this function is deprecated
  """
  def facet_filter(options, facet_opts\\[]) do
    IO.write :stderr, "warning: `Query.facet_filter` is deprecated, please use `Query.aggregation_filter` instead\n" <> Exception.format_stacktrace

    if is_list(options) do
      facet_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
    [facet_filter: extract(options) ++ facet_opts]
  end

  @doc false
  def custom_filters_score(options, custom_filters_score_opts\\[]) do
    if is_list(options) do
      custom_filters_score_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
    custom_filters_score = extract(options) ++ custom_filters_score_opts
    query = [query: custom_filters_score[:query]]
    filters = custom_filters_score[:filters]
    query = Dict.put(query, :filters, without_array(filters, []))
    [custom_filters_score: query ++ custom_filters_score_opts]
  end

  @doc false
  def boost(options) do
    [value, _, _] = extract_options(options)
    [boost: value]
  end

  @doc false
  def group(options, _object_opts\\[]) do
    if is_list(options) do
      _object_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
    [extract(options)]
  end

  @doc false
  def bool(block) do
    [bool: extract(block)]
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
  def location(options, location_opts\\[]) do
    if is_list(options) do
      location_opts = Enum.fetch!(options, 0)
      options = extract_do(options, 1)
    end
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
    [text_phrase: Dict.put([], to_atom(field), values)]
  end

  @doc false
  def text_phrase_prefix(options) do
    [field, values, _] = extract_options(options)
    [text_phrase_prefix: Dict.put([], to_atom(field), values)]
  end

  @doc false
  def create_resource(definition) do
    create_resource(definition, Tirexs.ElasticSearch.config())
  end

  @doc false
  def create_resource(definition, settings, opts\\[]) do
    url = if definition[:type] do
      "#{definition[:index]}/#{definition[:type]}"
    else
      "#{definition[:index]}"
    end

    { url, json } = { "#{url}/_search" <> to_param(opts, ""), to_resource_json(definition) }
    case Tirexs.ElasticSearch.post(url, json, settings) do
      {:ok, _, result} ->
        count         = result[:hits][:total]
        hits          = result[:hits][:hits]
        facets        = result[:facets]
        aggregations  = result[:aggregations]
        max_score     = result[:hits][:max_score]
        scroll_id     = result[:_scroll_id]

        result(count: count, hits: hits, facets: facets, aggregations: aggregations, max_score: max_score, _scroll_id: scroll_id)
      result  -> result
    end
  end

  @doc false
  def to_resource_json(definition), do: JSX.encode!(definition[:search])
end
