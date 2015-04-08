Code.require_file "../../test_helper.exs", __ENV__.file
defmodule Tirexs.PercolatorTest do
  use ExUnit.Case
  import Tirexs.Bulk
  import Tirexs.Percolator
  require Tirexs.ElasticSearch

  test :percolator do
    settings = Tirexs.ElasticSearch.config()
    Tirexs.ElasticSearch.delete("my-index/.percolator/1", settings)

    Tirexs.Bulk.store [index: "my-index", refresh: false], settings do
      create id: 1, message: "foo bar test"
      create id: 2, message: "bar bar test"
      create id: 3, message: "Old bonsai tree is down"
    end

    percolator = percolator [index: "my-index", name: 1] do
      query do
        match "message",  "bonsai tree"
      end
    end

    {_, _, body} = Tirexs.Percolator.create_resource(percolator, settings)

    assert body[:created]
    assert body[:_id]   == "1"

    percolator = percolator [index: "my-index", type: "message"] do
      doc do
        [[message: "A new bonsai tree in the office"]]
      end
    end

    {_, _, body} = Tirexs.Percolator.match(percolator, settings)

    assert body[:total] == 1
  end
end
