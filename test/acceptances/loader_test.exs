Code.require_file "../../test_helper.exs", __ENV__.file

defmodule Acceptances.LoaderTest do
  use ExUnit.Case

  import Tirexs.ElasticSearch
  require Tirexs.ElasticSearch

  @settings Tirexs.ElasticSearch.config()

  test :river_couchdb_dsl do
    river_couchdb_review_exs = Path.join([File.cwd!, "examples", "river", "couchdb_river.exs"])
    Tirexs.Loader.load(river_couchdb_review_exs)

    assert exist?("_river/test_river_dsl/_meta", @settings) == true
    delete("_river/test_river_dsl", @settings)
  end

  test :mappings_dsl do
    delete("test_dsl_index", @settings)
    mappings_exs = Path.join([File.cwd!, "examples", "mapping.exs"])
    Tirexs.Loader.load(mappings_exs)

    assert exist?("test_dsl_index", @settings) == true
  end

  test :search_dsl do
    search_exs = Path.join([File.cwd!, "examples", "search.exs"])
    Tirexs.Loader.load(search_exs)
  end

  test :settings_dsl do
    delete("test_dsl_settings", @settings)
    settings_exs = Path.join([File.cwd!, "examples", "settings.exs"])
    Tirexs.Loader.load(settings_exs)

    assert exist?("test_dsl_settings", @settings) == true
  end
end
