Code.require_file "../test_helper.exs", __FILE__
defmodule FilterTest do
  use ExUnit.Case
  import Tirexs
  use Tirexs.Filter
  use Tirexs.Query
  use Tirexs.ElasticSettings

  test :filter do
    query = filter do
      term "tag", "green"
    end

    assert query == [filter: [term: [tag: "green"]]]
  end

  test :exists do
    query = filter do
      exists "id"
    end

    assert query == [filter: [exists: [field: "id"]]]
  end

  test :filtered do
    query = query do
      filtered do
        query do
          query_string "elasticsearch", default_field: "message"
        end
        filter do
          bool do
            must do
              term "tag", "wow"
            end
            must_not do
              range "age", [from: 10, to: 20]
            end
            should do
              term "tag", "sometag"
              term "tag", "sometagtag"
            end
          end
        end
      end
    end

    assert query == [query: [filtered: [query: [query_string: [query: "elasticsearch", default_field: "message"]], filter: [bool: [must: [[term: [tag: "wow"]]], must_not: [[range: [age: [from: 10, to: 20]]]], should: [[term: [tag: "sometag"]],[term: [tag: "sometagtag"]]]]]]]]
  end

  test :ids do
    query = filter do
      ids "my_type", ["1", "4", "100"]
    end
    assert query == [filter: [ids: [type: "my_type", values: ["1","4","100"]]]]
  end

  test :limit do
    query = query do
      filtered do
        filter do
          limit 100
        end
        query do
          term "name.first", "shay"
        end
      end
    end

    assert query == [query: [filtered: [filter: [limit: [value: 100]], query: [term: ["name.first": "shay"]]]]]
  end

  test :type do
    query = filter do
      type "my_type"
    end

    assert query == [filter: [type: [value: "my_type"]]]
  end

  test :geo_bbox do
    query = query do
      filtered do
        query do
          match_all
        end
        filter do
          geo_bounding_box "pin.location", [top_left: [lat: 40.73, lon: -74.1], bottom_right: [lat: 40.717, lon: -73.99]]
        end
      end
    end

    assert query == [query: [filtered: [query: [match_all: []], filter: [geo_bounding_box: ["pin.location": [top_left: [lat: 40.73, lon: -74.1], bottom_right: [lat: 40.717, lon: -73.99]]]]]]]

    # settings = elastic_settings.new([port: 80, uri: "api.tunehog.com/kiosk-rts"])
    # IO.puts inspect(do_query(settings, "labeled/track", query))
  end

  test :filter_with_opts do
      query = query do
        filtered do
          query do
            match_all
          end
          filter [type: "indexed"] do
            geo_bounding_box "pin.location", [top_left: [lat: 40.73, lon: -74.1], bottom_right: [lat: 40.717, lon: -73.99]]
          end
        end
      end

      assert query == [query: [filtered: [query: [match_all: []], filter: [geo_bounding_box: ["pin.location": [top_left: [lat: 40.73, lon: -74.1], bottom_right: [lat: 40.717, lon: -73.99]]], type: "indexed"]]]]
  end

  test :geo_distance do
    query = query do
      filtered do
        query do
          match_all
        end
        filter do
          geo_distance "pin.location", "40,-70", distance: "12km"
        end
      end
    end

    assert query == [query: [filtered: [query: [match_all: []], filter: [geo_distance: ["pin.location": "40,-70", distance: "12km"]]]]]
  end

  test :geo_distance_range do
    query = query do
      filtered do
        query do
          match_all
        end
        filter do
          geo_distance_range "pin.location", [lat: 40, lon: -70], [from: "200km", to: "400km"]
        end
      end
    end

    assert query == [query: [filtered: [query: [match_all: []], filter: [geo_distance_range: ["pin.location": [lat: 40, lon: -70], from: "200km", to: "400km"]]]]]
  end

  test :geo_polygon do
    query = query do
      filtered do
        query do
          match_all
        end
        filter do
          geo_polygon "person.location", [[lat: 40, lon: -70], [lat: 30, lon: -80], [lat: 20, lon: -90]]
        end
      end
    end

    assert query == [query: [filtered: [query: [match_all: []], filter: [geo_polygon: ["person.location": [points: [[lat: 40, lon: -70],[lat: 30, lon: -80],[lat: 20, lon: -90]]]]]]]]
  end

  test :geo_shape do
    query = query do
      filtered do
        query do
          match_all
        end
        filter do
          geo_shape do
            location do
              shape type: "envelope", coordinates: [[-45,45],[45,-45]]
            end
          end
        end
      end
    end

    assert query == [query: [filtered: [query: [match_all: []], filter: [geo_shape: [location: [shape: [type: "envelope", coordinates: [[-45,45],[45,-45]]]]]]]]]
  end

  test :geo_shape_indexed_shape do
    query = query do
      filtered do
        query do
          match_all
        end
        filter do
          geo_shape do
            location [relation: "within"] do
              indexed_shape [id: "New Zealand",
                            type: "countries",
                            index: "shapes",
                            shape_field_name: "shape"]
            end
          end
        end
      end
    end

    assert query == [query: [filtered: [query: [match_all: []], filter: [geo_shape: [location: [indexed_shape: [id: "New Zealand", type: "countries", index: "shapes", shape_field_name: "shape"], relation: "within"]]]]]]
  end

  test :has_child do
    query = filter [type: "blog_tag"] do
      has_child do
        query do
          term "tag", "something"
        end
      end
    end

    assert query == []
  end

end