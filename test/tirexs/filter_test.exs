Code.require_file "../../test_helper.exs", __FILE__
defmodule FiltersTest do
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
    query = filter do
      has_child [type: "blog_tag"] do
        query do
          term "tag", "something"
        end
      end
    end

    assert query == [filter: [has_child: [query: [term: [tag: "something"]], type: "blog_tag"]]]
  end

  test :has_parent do
    query = filter do
      has_parent [type: "blog"] do
        query do
          term "tag", "something"
        end
      end
    end

    assert query == [filter: [has_parent: [query: [term: [tag: "something"]], type: "blog"]]]
  end

  test :match_all do
    query = filter do
        match_all
    end

    assert query == [filter: [match_all: []]]
  end

  test :missing do
    query = filter do
      missing "user", [existence: true, null_value: true]
    end

    assert query == [filter: [missing: [field: "user", existence: true, null_value: true]]]
  end

  test :not do
    query = query do
      filtered do
        query do
          term "name.first", "shay"
        end
        filter do
          _not do
            range "postDate", [from: "2010-03-01", to: "2010-04-01"]
          end
        end
      end
    end

    assert query == [query: [filtered: [query: [term: ["name.first": "shay"]], filter: [not: [range: [postDate: [from: "2010-03-01", to: "2010-04-01"]]]]]]]
  end

  test :not_with_params do
    query = query do
      filtered do
        query do
          term "name.first", "shay"
        end
        filter do
          _not [_cache: true] do
            filter do
              range "postDate", [from: "2010-03-01", to: "2010-04-01"]
            end
          end
        end
      end
    end

    assert query == [query: [filtered: [query: [term: ["name.first": "shay"]], filter: [not: [filter: [range: [postDate: [from: "2010-03-01", to: "2010-04-01"]]], _cache: true]]]]]
  end

  test :numeric_range do
    query = filter do
      numeric_range "age", [from: "10",
                            to: "20",
                            include_lower: true,
                            include_upper: false]
    end

    assert query == [filter: [numeric_range: [age: [from: "10", to: "20", include_lower: true, include_upper: false]]]]
  end

  test :prefix do
    query = filter do
      prefix "user", "ki"
    end

    assert query == [filter: [prefix: [user: "ki"]]]
  end

  test :query do
    query = filter do
      fquery [_cache: true] do
        query do
          query_string "elasticsearch", default_field: "message"
        end
      end
    end

    assert query == [filter: [fquery: [query: [query_string: [query: "elasticsearch", default_field: "message"]], _cache: true]]]
  end

  test :range do
    query = filter do
      range "age", [from: "10",
                    to: "20",
                    include_lower: true,
                    include_upper: false]
    end

    assert query == [filter: [range: [age: [from: "10", to: "20", include_lower: true, include_upper: false]]]]
  end

  test :script do
    query = query do
      filtered do
        query do
          match_all
        end
        filter do
          script "doc['num1'].value > param1", [param1: 1]
        end
      end
    end

    assert query == [query: [filtered: [query: [match_all: []], filter: [script: [script: "doc['num1'].value > param1", params: [param1: 1]]]]]]
  end

  test :term do
    query = filter do
      term "user", "kimchy", _cache: false
    end

    assert query == [filter: [term: [user: "kimchy", _cache: false]]]
  end

  test :terms do
    query = filter do
      terms "user", ["kimchy", "elasticsearch"], execution: "bool", _cache: true
    end
    assert query == [filter: [terms: [user: ["kimchy","elasticsearch"], execution: "bool", _cache: true]]]
  end

  test :nested do
    query = query do
      filtered do
        query do
          match_all
        end
        filter do
          nested [path: "obj1", _cache: true] do
            query do
              bool do
                must do
                  match "obj1.name", "blue"
                  range "obj1.count", [gt: 5]
                end
              end
            end
          end
        end
      end
    end
    assert query == [query: [filtered: [query: [match_all: []], filter: [nested: [query: [bool: [must: [[match: ["obj1.name": [query: "blue"]]],[range: ["obj1.count": [gt: 5]]]]]], path: "obj1", _cache: true]]]]]
  end

  test :and do
    query = query do
      filtered do
        query do
          term "name.first", "shay"
        end
        filter do
          _and [_cache: true] do
            filters do
              range "postDate", [from: "2010-03-01",
                                 to: "2010-04-01"]
              prefix "name.second", "ba"
            end
          end
        end
      end
    end

    assert query == [query: [filtered: [query: [term: ["name.first": "shay"]], filter: [and: [filters: [[range: [postDate: [from: "2010-03-01", to: "2010-04-01"]]],[prefix: ["name.second": "ba"]]], _cache: true]]]]]
  end

  test :or do
    query = query do
      filtered do
        query do
          term "name.first", "shay"
        end
        filter do
          _or [_cache: true] do
            filters do
              range "postDate", [from: "2010-03-01",
                                 to: "2010-04-01"]
              prefix "name.second", "ba"
            end
          end
        end
      end
    end

    assert query == [query: [filtered: [query: [term: ["name.first": "shay"]], filter: [or: [filters: [[range: [postDate: [from: "2010-03-01", to: "2010-04-01"]]],[prefix: ["name.second": "ba"]]], _cache: true]]]]]
    # settings = elastic_settings.new([uri: "localhost"])
    # IO.puts inspect(do_query(settings, "top_club_places", query))
  end


end