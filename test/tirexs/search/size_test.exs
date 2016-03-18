Code.require_file "../../../test_helper.exs", __ENV__.file

defmodule Tirexs.Search.SizeTest do
  use ExUnit.Case

  import Tirexs.Search

  test "size" do
    size = size 10

    expected = [size: 10]
    assert size == expected
  end
end
