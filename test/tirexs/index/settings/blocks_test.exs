Code.require_file "../../../../test_helper.exs", __ENV__.file

defmodule Tirexs.Index.Settings.BlocksTest do
  use ExUnit.Case

  import Tirexs.Index.Settings


  test "settings w/ blocks" do
    index = [name: "bear_test"]

    settings do
      blocks read_only: true, read: true, write: false, metadata: true
    end

    expected = [index: [blocks: [read_only: true, read: true, write: false, metadata: true]]]
    assert index[:settings] == expected
  end
end
