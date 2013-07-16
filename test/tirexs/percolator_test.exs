Code.require_file "../../test_helper.exs", __FILE__
defmodule Tirexs.PerlocatorTest do
  use ExUnit.Case
  import Tirexs.Percolator

  test :simple_percolator do
    percolator = percolator do
      query do
        term "field1", "value1"
      end
    end

    assert percolator == [query: [term: [field1: "value1"]]]
  end

  test :with_param do
      percolator = percolator [color: "blue"] do
        query do
          term "field1", "value1"
        end
      end

      assert percolator == [query: [term: [field1: "value1"]], color: "blue"]
    end

    test :with_doc do
      percolator = percolator do
        doc do
          [[field1: "value1"]]
        end
        query do
          term "field1", "value1"
        end
      end

      assert percolator == [doc: [field1: "value1"], query: [term: [field1: "value1"]]]
    end

end