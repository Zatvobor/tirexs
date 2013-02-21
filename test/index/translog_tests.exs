Code.require_file "../../test_helper.exs", __FILE__

defmodule TranslogTest do
  use ExUnit.Case
  import Tirexs
  use Tirexs.Index.Settings

  test :blocks_settings do
    index = init_index([name: "bear_test"])

    settings do
      translog flush_threshold_ops: "",
               flush_threshold_size: 2002,
               flush_threshold_period: 1,
               disable_flush: true
    end

    assert index[:settings] == [index: [translog: [flush_threshold_ops: "", flush_threshold_size: 2002, flush_threshold_period: 1, disable_flush: true]]]
  end

end