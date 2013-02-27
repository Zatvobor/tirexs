defmodule Tirexs.Query.GeoShare do
  import Tirexs.Query.Helpers
  import Tirexs.Helpers

  def location(options, location_opts//[]) do
    if is_list(options) do
      location_opts = Enum.at!(options, 0)
      options = extract_do(options, 1)
    end
    [location: scoped_query(options) ++ location_opts]
  end

  def shape(options) do
    [shape: options]
  end

  def indexed_shape(options) do
    [indexed_shape: options]
  end
end