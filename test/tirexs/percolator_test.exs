Code.require_file "../../test_helper.exs", __ENV__.file

defmodule Tirexs.PerlocatorTest do
  use ExUnit.Case

  import Tirexs.Percolator


  test "percolator query in general" do
    percolator = percolator do
      query do
        term "field1", "value1"
      end
    end

    expected = [query: [term: [field1: "value1"]]]
    assert percolator == expected
  end

  test "percolator query w/ options" do
    percolator = percolator [color: "blue"] do
      query do
        term "field1", "value1"
      end
    end

    expected = [query: [term: [field1: "value1"]], color: "blue"]
    assert percolator == expected
  end

  test "percolator query w/ doc" do
    percolator = percolator do
      doc do
        [[field1: "value1"]]
      end
      query do
        term "field1", "value1"
      end
    end

    expected = [doc: [field1: "value1"], query: [term: [field1: "value1"]]]
    assert percolator == expected
  end
end
