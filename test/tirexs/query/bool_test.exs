Code.require_file "../../../test_helper.exs", __FILE__
defmodule Query.Bool.Test do
  use ExUnit.Case
  import Tirexs
  use Tirexs.Query
  use Tirexs.ElasticSettings

  @url "labeled/track"

  test :simple_bool do
    query = query do
      bool do
        must do
          match "artist_uri",  "medianet:artist:261633", operator: "and"
        end
      end
    end

    assert query == [query: [bool: [must: [[match: [artist_uri: [query: "medianet:artist:261633", operator: "and"]]]]]]]
  end

  test :advance_bool do
    query = query do
      bool do
        must do
          match "artist", "Madonna", operator: "and"
          match "title", "My", operator: "and"
          match "color_tune", "red,orange"
          match "genre", "Alternative/Indie,Christian/Gospel"
          range "release_year", from: 1950, to: 2013
          range "energy_mood", from: 0, to: 30
        end

        should do
          match "genre", "Alternative/Indie,Christian/Gospel"
          range "release_year", from: 1950, to: 2013
        end

        must_not do
          match "genre", "Alternative/Indie,Christian/Gospel"
        end
      end
    end

    assert query == [query: [bool: [must: [[match: [artist: [query: "Madonna", operator: "and"]]],[match: [title: [query: "My", operator: "and"]]],[match: [color_tune: [query: "red,orange"]]],[match: [genre: [query: "Alternative/Indie,Christian/Gospel"]]],[range: [release_year: [from: 1950, to: 2013]]],[range: [energy_mood: [from: 0, to: 30]]]], should: [[match: [genre: [query: "Alternative/Indie,Christian/Gospel"]]],[range: [release_year: [from: 1950, to: 2013]]]], must_not: [[match: [genre: [query: "Alternative/Indie,Christian/Gospel"]]]]]]]
  end
end