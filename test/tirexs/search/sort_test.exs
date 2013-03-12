Code.require_file "../../../test_helper.exs", __FILE__
defmodule SortTest do
  use ExUnit.Case
  import Tirexs.Search

  test :sort_list do
    sort = sort do
      [
        [post_date: [reverse: true]],
        [name: "desc"],
        [age: "desc"]
      ]
    end

    assert sort == [sort: [[post_date: [reverse: true]],[name: "desc"],[age: "desc"]]]
  end

  test :sort_srcipt do
    sort = sort do
      [
        _script: [script: "doc['field_name'].value * factor", type: "number", params: [factor: 1.1]],
        order: "asc"
      ]
    end

    assert sort == [sort: [_script: [script: "doc['field_name'].value * factor", type: "number", params: [factor: 1.1]], order: "asc"]]
  end

  test :_geo_distance_sort do
    sort = sort do
      [
        "_geo_distance": ["pin.location": [-70, 40], order: "asc", unit: "km"]
      ]
    end

    assert sort == [sort: [_geo_distance: ["pin.location": [-70,40], order: "asc", unit: "km"]]]
  end
end