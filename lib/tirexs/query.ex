defmodule Tirexs.Query do

  #Missing query type: [dis_max]

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

  defmacro text(field, value, options) do
    quote do
      [field, value, options] = [unquote(field), unquote(value), unquote(options)]
      IO.puts field
    end
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

  defmacro field(field, value) do
    #note value can be a dict or string =)
    quote do
      [field, value] = [unquote(field), unquote(value)]
    end
  end



end