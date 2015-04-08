Code.require_file "../../test_helper.exs", __ENV__.file
defmodule Tirexs.PercolatorTest do
  use ExUnit.Case
  import Tirexs.Percolator
  require Tirexs.ElasticSearch

  test :percolator do
    settings = Tirexs.ElasticSearch.config()
    Tirexs.ElasticSearch.delete(".percolator/my-index", settings)

    percolator = percolator [index: "my-index", name: "message"] do
      query do
        match "message",  "bonsai tree"
      end
    end

    {_, _, body} = Tirexs.Percolator.create_resource(percolator, settings)

    assert body[:created]
    assert body[:_id]   == "message"
    assert body[:_type] == "my-index"

    percolator = percolator [index: "my-index"] do
      doc do
        [[message: "A new bonsai tree in the office"]]
      end
    end

    {_, _, body} = Tirexs.Percolator.match(percolator, settings)

    assert body[:total] == 1
  end
end
