Code.require_file "../../../test_helper.exs", __ENV__.file

defmodule Tirexs.Search.SuggestTest do
  use ExUnit.Case

  import Tirexs.Search.Suggest


  test "suggest" do
    suggest = suggest do
      my_own_suggest do
        fuzzy "field", "body"
      end
    end

    expected = [suggest: [my_own_suggest: [fuzzy: [field: "body"]]]]
    assert suggest == expected
  end
end
