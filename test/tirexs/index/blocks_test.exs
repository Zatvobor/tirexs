Code.require_file "../../../test_helper.exs", __FILE__

defmodule Tirexs.Index.BlocksTest do
  use ExUnit.Case
  import Tirexs.Index.Settings

  test :blocks_settings do
    index = [name: "bear_test"]

    settings do
      blocks read_only: true,
             read: true,
             write: false,
             metadata: true
    end

    assert index[:settings] == [index: [blocks: [read_only: true, read: true, write: false, metadata: true]]]
  end

end