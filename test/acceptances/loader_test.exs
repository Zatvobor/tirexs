Code.require_file "../../test_helper.exs", __FILE__

defmodule Tirexs.LoaderTest do
  use ExUnit.Case

  import Tirexs
  import Tirexs.HTTP

  @path Path.join([File.cwd!, "examples"])

   test :load_dsl_file do
     settings = Tirexs.ElasticSearch.Config.new()

     Tirexs.Loader.load_all(@path)

     assert exist?(settings, "test_dsl_index") == true
     delete(settings, "test_dsl_index")
     assert exist?(settings, "test_dsl_index") == false
     assert exist?(settings, "test_dsl_setting") == true
     delete(settings, "test_dsl_setting")
     assert exist?(settings, "test_dsl_setting") == false
   end

   test :river_dsl do
    river_path = Path.join([File.cwd!, "examples", "river"])
    settings = Tirexs.ElasticSearch.Config.new()

    Tirexs.Loader.load_all(river_path)

    assert exist?(settings, "_river/tets_river_dsl/_meta") == true
    delete(settings, "_river/tets_river_dsl")
    assert exist?(settings, "_river/tets_river_dsl/_meta") == false
   end

   test :search_dsl do
     search_file_path = Path.join([File.cwd!, "examples"])
     Tirexs.Loader.load(search_file_path <> "/search.exs")
   end
end