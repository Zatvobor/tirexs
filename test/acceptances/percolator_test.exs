defmodule Tirexs.PercolatorTest do
  use ExUnit.Case

  import Tirexs.Bulk
  import Tirexs.Percolator

  alias Tirexs.{HTTP, Percolator}


  test :percolator do
    HTTP.delete("my-index/.percolator/1")

    Tirexs.Bulk.store [index: "my-index", refresh: false] do
      create id: 1, message: "foo bar test"
      create id: 2, message: "bar bar test"
      create id: 3, message: "Old bonsai tree is down"
    end

    percolator = percolator [index: "my-index", name: 1] do
      query do
        match "message",  "bonsai tree"
      end
    end

    {_, _, body} = Percolator.create_resource(percolator)

    assert body[:created]
    assert body[:_id]   == "1"

    percolator = percolator [index: "my-index", type: "message"] do
      doc do
        [[message: "A new bonsai tree in the office"]]
      end
    end

    {_, _, body} = Percolator.match(percolator)

    assert body[:total] == 1
  end
end
