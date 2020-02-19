Code.require_file "../../../../test_helper.exs", __ENV__.file

defmodule Tirexs.Index.Settings.SetTest do
  use ExUnit.Case

  import Tirexs.Index.Settings


  test "settings w/ set" do
    index = [name: "bear_test"]

    settings do
      set number_of_replicas: 3, auto_expand_replicas: 5
    end

    expected = [number_of_replicas: 3, auto_expand_replicas: 5]
    assert index[:settings] == expected
  end
end
