Code.require_file "../../../test_helper.exs", __ENV__.file

defmodule Tirexs.Search.FromTest do
  use ExUnit.Case

  import Tirexs.Search

  test "from" do
    from = from 10

    expected = [from: 10]
    assert from == expected
  end
end
