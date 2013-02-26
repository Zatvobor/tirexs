defmodule Tirexs.Query do

  #Missing query type: [filtered]

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
    [field, value, options] = extract_options(options)
    [match: Dict.put([], to_atom(field), [query: value] ++ options)]
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
    [field, values, _] = extract_options(options)
    [term: Dict.put([], to_atom(field), values)]
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


end