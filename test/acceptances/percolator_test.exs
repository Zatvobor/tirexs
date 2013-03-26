Code.require_file "../../test_helper.exs", __FILE__
defmodule Tirexs.PerlocatorTest do
  use ExUnit.Case
  import Tirexs.Percolator

  test :percolator do

    settings = Tirexs.ElasticSearch.Config.new()
    Tirexs.ElasticSearch.delete("_percolator/test/kuku", settings)
    percolator = percolator [index: "test", name: "kuku"] do
      query do
        term "field1", "value1"
      end
    end

    {_, _, body} = Tirexs.Percolator.create_resource(percolator, settings)

    doc = [index: "test", doc: [field1: "value1"]]

    assert body["_id"] == "kuku"

    # {_,_, body} = Tirexs.Percolator.matches(doc, settings)

    # IO.puts inspect(body)
  end
end