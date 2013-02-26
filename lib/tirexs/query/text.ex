defmodule Tirexs.Query.Text do
  import Tirexs.Query.Helpers
  import Tirexs.Helpers

  def text_phrase(options) do
    [field, values, _] = extract_options(options)
    [text_phrase: Dict.put([], to_atom(field), values)]
  end

  def text_phrase_prefix(options) do
    [field, values, _] = extract_options(options)
    [text_phrase_prefix: Dict.put([], to_atom(field), values)]
  end
end