defmodule Tirexs.Filter.Geo do
  import Tirexs.Query.Helpers
  import Tirexs.Helpers

  def geo_bounding_box(options) do
    [field, value, options] = extract_options(options)
    [geo_bounding_box: Dict.put([], to_atom(field), value) ++ options]
  end
end