Code.require_file "../../../test_helper.exs", __ENV__.file

defmodule Tirexs.Search.SortTest do
  use ExUnit.Case

  import Tirexs.Search


  test "sort" do
    sort = sort do
      [
        [post_date: [reverse: true]],
        [name: "desc"],
        [age: "desc"]
      ]
    end

    expected = [sort: [[post_date: [reverse: true]],[name: "desc"],[age: "desc"]]]
    assert sort == expected
  end

  test "sort w/ script" do
    sort = sort do
      [
        _script: [script: "doc['field_name'].value * factor", type: "number", params: [factor: 1.1]],
        order: "asc"
      ]
    end

    expected = [sort: [_script: [script: "doc['field_name'].value * factor", type: "number", params: [factor: 1.1]], order: "asc"]]
    assert sort == expected
  end

  test "sort w/ _geo_distance_sort" do
    sort = sort do
      [
        _geo_distance: ["pin.location": [-70, 40], order: "asc", unit: "km"]
      ]
    end

    expected = [sort: [_geo_distance: ["pin.location": [-70,40], order: "asc", unit: "km"]]]
    assert sort == expected
  end
end
