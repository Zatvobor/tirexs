defmodule Tirexs.Query do

  #Missing query type: [custom_filters_score]

  import Tirexs.Query.Helpers
  import Tirexs.Helpers

  defmacro __using__(_) do
    quote do
      import unquote(Tirexs.Query)
      use unquote(Tirexs.Query.Bool)
      import unquote(Tirexs.Query.DisMax)
      use unquote(Tirexs.Query.Filtered)
    end
  end

  defmacro query([do: block]) do
    [query: scoped_query(block)]
  end

  def _query(options) do
    [query: scoped_query(options)]
  end

  def match(options) do
    case options do
      [options] -> [match: scoped_query(extract_do([options]))]
      _ ->
        [field, value, options] = extract_options(options)
        [match: Dict.put([], to_atom(field), [query: value] ++ options)]
    end


  end

  def range(options) do
    [field, value, _] = extract_options(options)
    [range: Dict.put([], to_atom(field), value)]
  end

  def multi_match(options) do
    [query, fields, options] = extract_options(options)
    [multi_match: [query: query, fields: fields]]
  end

  def boosting(options, boosting_opts//[]) do
    if is_list(options) do
      boosting_opts = Enum.at!(options, 0)
      options = extract_do(options, 1)
    end
    [boosting: scoped_query(options) ++ boosting_opts]
  end

  def ids(options) do
    [type, values, _] = extract_options(options)
    [ids: [type: type, values: values]]
  end

  def query_string(options) do
    [query, options, _] = extract_options(options)
    [query_string: [query: query] ++ options]
  end

  def custom_score(options, custom_score_opts//[]) do
    if is_list(options) do
      custom_score_opts = Enum.at!(options, 0)
      options = extract_do(options, 1)
    end
    [custom_score: scoped_query(options) ++ custom_score_opts]
  end

  def custom_boost_factor(options, custom_boost_factor_opts//[]) do
    if is_list(options) do
      custom_boost_factor_opts = Enum.at!(options, 0)
      options = extract_do(options, 1)
    end
    [custom_boost_factor: scoped_query(options) ++ custom_boost_factor_opts]
  end

  def constant_score(options, constant_score_opts//[]) do
    if is_list(options) do
      constant_score_opts = Enum.at!(options, 0)
      options = extract_do(options, 1)
    end
    [constant_score: scoped_query(options) ++ constant_score_opts]
  end

  def dis_max(options, dis_max_opts//[]) do
    if is_list(options) do
      dis_max_opts = Enum.at!(options, 0)
      options = extract_do(options, 1)
    end
    [dis_max: scoped_query(options) ++ dis_max_opts]
  end

  def term(options) do
    [field, values, options] = extract_options(options)
    [term: Dict.put(options, to_atom(field), values)]
  end

  def field(options) do
    [field, values, _] = extract_options(options)
    [field: Dict.put([], to_atom(field), values)]
  end

  def flt(options) do
    [value, fields, options] = extract_options(options)
    [fuzzy_like_this: [like_text: value, fields: fields] ++ options]
  end

  def flt_field(options) do
    [field, options, _] = extract_options(options)
    [fuzzy_like_this_field: Dict.put([], to_atom(field), options)]
  end

  def fuzzy(options) do
    [field, values, _] = extract_options(options)
    [fuzzy: Dict.put([], to_atom(field), values)]
  end

  def has_child(options, has_child_opts//[]) do
    if is_list(options) do
      has_child_opts = Enum.at!(options, 0)
      options = extract_do(options, 1)
    end
    [has_child: scoped_query(options) ++ has_child_opts]
  end

  def has_parent(options, has_parent_opts//[]) do
    if is_list(options) do
      has_parent_opts = Enum.at!(options, 0)
      options = extract_do(options, 1)
    end
    [has_parent: scoped_query(options) ++ has_parent_opts]
  end

  def match_all(options) do
    Dict.put([], :match_all,  options)
  end

  def mlt(options) do
    [value, fields, options] = extract_options(options)
    [more_like_this: [like_text: value, fields: fields] ++ options]
  end

  def mlt_field(options) do
    [field, options, _] = extract_options(options)
    [more_like_this_field: Dict.put([], to_atom(field), options)]
  end

  def prefix(options) do
    [field, values, _] = extract_options(options)
    [prefix: Dict.put([], to_atom(field), values)]
  end

  def span_first(options, span_first_opts//[]) do
    if is_list(options) do
      span_first_opts = Enum.at!(options, 0)
      options = extract_do(options, 1)
    end
    [span_first: scoped_query(options) ++ span_first_opts]
  end

  def span_term(options) do
    [field, options, _] = extract_options(options)
    [span_term: Dict.put([], to_atom(field), options)]
  end

  def span_near(options, span_near_opts//[]) do
    if is_list(options) do
      span_near_opts = Enum.at!(options, 0)
      options = extract_do(options, 1)
    end
    [span_near: scoped_query(options) ++ span_near_opts]
  end

  def span_not(options, span_not_opts//[]) do
    if is_list(options) do
      span_not_opts = Enum.at!(options, 0)
      options = extract_do(options, 1)
    end
    [span_not: scoped_query(options) ++ span_not_opts]
  end

  def span_or(options, span_or_opts//[]) do
    if is_list(options) do
      span_or_opts = Enum.at!(options, 0)
      options = extract_do(options, 1)
    end
    [span_or: scoped_query(options) ++ span_or_opts]
  end

  def terms(options) do
    [field, value, options] = extract_options(options)
    [terms: Dict.put([], to_atom(field), value) ++ options]
  end

  def top_children(options, top_children_opts//[]) do
    if is_list(options) do
      top_children_opts = Enum.at!(options, 0)
      options = extract_do(options, 1)
    end
    [top_children: scoped_query(options) ++ top_children_opts]
  end

  def wildcard(options) do
    [field, options, _] = extract_options(options)
    [wildcard: Dict.put([], to_atom(field), options)]
  end

  def indices(options, indices_opts//[]) do
    if is_list(options) do
      indices_opts = Enum.at!(options, 0)
      options = extract_do(options, 1)
    end
    [indices: scoped_query(options) ++ indices_opts]
  end

  def text(options) do
    [field, values, _] = extract_options(options)
    [text: Dict.put([], to_atom(field), values)]
  end

  def geo_shape(options, geo_shape_opts//[]) do
    if is_list(options) do
      geo_shape_opts = Enum.at!(options, 0)
      options = extract_do(options, 1)
    end
    [geo_shape: scoped_query(options) ++ geo_shape_opts]
  end

  def nested(options, nested_opts//[]) do
    if is_list(options) do
      nested_opts = Enum.at!(options, 0)
      options = extract_do(options, 1)
    end
    [nested: scoped_query(options) ++ nested_opts]
  end

  # def custom_filters_score(options, custom_filters_score_opts//[]) do
  #   if is_list(options) do
  #     custom_filters_score_opts = Enum.at!(options, 0)
  #     options = extract_do(options, 1)
  #   end
  #   [custom_filters_score: scoped_query(options) ++ custom_filters_score_opts]
  # end
  #
  # def boost(options) do
  #   [value, _, _] = extract_options(options)
  #   [boost: value]
  # end
  #
  # def object(options, object_opts//[]) do
  #   if is_list(options) do
  #     object_opts = Enum.at!(options, 0)
  #     options = extract_do(options, 1)
  #   end
  #   scoped_query(options) ++ object_opts
  # end


end