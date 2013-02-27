defmodule Tirexs.Filter.Geo do
  import Tirexs.Query.Helpers
  import Tirexs.Helpers

  def geo_bounding_box(options) do
    [field, value, options] = extract_options(options)
    [geo_bounding_box: Dict.put([], to_atom(field), value) ++ options]
  end

  def geo_distance(options) do
    [field, value, options] = extract_options(options)
    [geo_distance: Dict.put([], to_atom(field), value) ++ options]
  end

  def geo_distance_range(options) do
    [field, value, options] = extract_options(options)
    [geo_distance_range: Dict.put([], to_atom(field), value) ++ options]
  end

  def geo_polygon(options) do
    [field, value, options] = extract_options(options)
    [geo_polygon: Dict.put([], to_atom(field), [points: value]) ++ options]
  end
end