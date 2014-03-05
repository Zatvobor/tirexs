Code.require_file "../../test_helper.exs", __ENV__.file
defmodule Tirexs.RiverTest do
  use ExUnit.Case
  use Tirexs.River

  test :river do
    river = init_river(name: "test_river")
    river [type: "couchdb"] do

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
