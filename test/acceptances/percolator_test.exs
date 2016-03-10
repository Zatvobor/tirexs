defmodule Tirexs.PercolatorTest do
  use ExUnit.Case

  import Tirexs.Bulk
  import Tirexs.Percolator

  alias Tirexs.{HTTP, Percolator}


  setup do
    HTTP.delete("my-index/.percolator/1") && :ok
  end

  test :percolator do
    payload = bulk([index: "my-index", type: "my-type"]) do
      create [
        [ id: 1, message: "foo bar test" ],
        [ id: 2, message: "bar bar test" ],
        [ id: 3, message: "Old bonsai tree is down" ]
      ]
    end
    Tirexs.bump!(payload)._bulk({[refresh: true]})

    percolator = percolator([index: "my-index", name: 1]) do
      query do
        match "message",  "bonsai tree"
      end
    end
    {_, _, body} = Percolator.create_resource(percolator)

    assert body[:created]
    assert body[:_id]   == "1"

    percolator = percolator([index: "my-index", type: "message"]) do
      doc do
        [[message: "A new bonsai tree in the office"]]
      end
    end
    {_, _, body} = Percolator.match(percolator)

    assert body[:total] == 1
  end
end
