Code.require_file "../test_helper.exs", __FILE__
defmodule RiverTest do
  use ExUnit.Case
  import Tirexs
  use Tirexs.River

  test :river do
    river = init_river(name: "test_river")
    river do
      type "couchdb"

      index do
        [
          bulk_size: 100,
          bulk_timeout: "1ms",
          index: "test"
        ]
      end

    end

    assert river[:name] == "test_river"
    assert river[:type] == "couchdb"
    assert river[:index] == [bulk_size: 100, bulk_timeout: "1ms", index: "test"]
  end

end