Code.require_file "../../../test_helper.exs", __ENV__.file

defmodule Tirexs.Query.BoolTest do
  use ExUnit.Case

  import Tirexs.Query


  test "bool clause w/ single occurrence type" do
    query = query do
      bool do
        must do
          match "artist_uri",  "medianet:artist:261633", operator: "and"
        end
      end
    end

    expected = [query: [bool: [must: [[match: [artist_uri: [query: "medianet:artist:261633", operator: "and"]]]]]]]
    assert query == expected
  end

  test "bool clause w/ parameters" do
    query = query do
      bool [minimum_should_match: 1] do
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

    expected = [query: [bool: [must: [[match: [artist: [query: "Madonna", operator: "and"]]],[match: [title: [query: "My", operator: "and"]]],[match: [color_tune: [query: "red,orange"]]],[match: [genre: [query: "Alternative/Indie,Christian/Gospel"]]],[range: [release_year: [from: 1950, to: 2013]]],[range: [energy_mood: [from: 0, to: 30]]]], should: [[match: [genre: [query: "Alternative/Indie,Christian/Gospel"]]],[range: [release_year: [from: 1950, to: 2013]]]], must_not: [[match: [genre: [query: "Alternative/Indie,Christian/Gospel"]]]], minimum_should_match: 1]]]
    assert query == expected
  end

  test "bool clause w/ multiple occurrence types" do
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

    expected = [query: [bool: [must: [[match: [artist: [query: "Madonna", operator: "and"]]],[match: [title: [query: "My", operator: "and"]]],[match: [color_tune: [query: "red,orange"]]],[match: [genre: [query: "Alternative/Indie,Christian/Gospel"]]],[range: [release_year: [from: 1950, to: 2013]]],[range: [energy_mood: [from: 0, to: 30]]]], should: [[match: [genre: [query: "Alternative/Indie,Christian/Gospel"]]],[range: [release_year: [from: 1950, to: 2013]]]], must_not: [[match: [genre: [query: "Alternative/Indie,Christian/Gospel"]]]]]]]
    assert query == expected
  end
end
