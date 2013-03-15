Code.require_file "../../../test_helper.exs", __FILE__
defmodule SuggestTest do
  use ExUnit.Case
  import Tirexs.Search.Suggest

  test :create_suggest do
    suggest = suggest do
      my_suggest_1 do
        fuzzy "field", "body"
      end
    end

    assert suggest == [suggest: [my_suggest_1: [fuzzy: [field: "body"]]]]
  end
end