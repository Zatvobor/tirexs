Code.require_file "../../test_helper.exs", __FILE__

defmodule Acceptances.LoaderTest do
  use ExUnit.Case

  import Tirexs.ElasticSearch

  @path Path.join([File.cwd!, "examples"])

   test :load_dsl_file do
     settings = Tirexs.ElasticSearch.Config.new()

     Tirexs.Loader.load_all(@path)

     assert exist?("test_dsl_index", settings) == true
     delete("test_dsl_index", settings)
     assert exist?("test_dsl_index", settings) == false
     assert exist?("test_dsl_setting", settings) == true
     delete("test_dsl_setting", settings)
     assert exist?("test_dsl_setting", settings) == false
   end

   test :river_dsl do
    river_path = Path.join([File.cwd!, "examples", "river"])
    settings = Tirexs.ElasticSearch.Config.new()

    Tirexs.Loader.load_all(river_path)

    assert exist?("_river/tets_river_dsl/_meta", settings) == true
    delete("_river/tets_river_dsl", settings)
    assert exist?("_river/tets_river_dsl/_meta", settings) == false
   end

   test :search_dsl do
     search_file_path = Path.join([File.cwd!, "examples"])
     Tirexs.Loader.load(search_file_path <> "/search.exs")
   end
end