Code.require_file "../../test_helper.exs", __ENV__.file

defmodule Acceptances.LoaderTest do
  use ExUnit.Case

  import Tirexs.ElasticSearch
  require Tirexs.ElasticSearch

  @settings Tirexs.ElasticSearch.config()


  test :mappings_dsl do
    delete("bear_test", @settings)
    mappings_exs = Path.join([File.cwd!, "examples", "mapping.exs"])
    Tirexs.Loader.load(mappings_exs)

    assert exist?("bear_test", @settings) == true
  end

  test :search_dsl do
    search_exs = Path.join([File.cwd!, "examples", "search.exs"])
    Tirexs.Loader.load(search_exs)
  end

  test :settings_dsl do
    delete("bear_test", @settings)
    settings_exs = Path.join([File.cwd!, "examples", "settings.exs"])
    Tirexs.Loader.load(settings_exs)

    assert exist?("bear_test", @settings) == true
  end
end
