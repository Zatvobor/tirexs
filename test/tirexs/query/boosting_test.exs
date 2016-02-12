Code.require_file "../../../test_helper.exs", __ENV__.file

defmodule Tirexs.Query.BoostingTest do
  use ExUnit.Case

  import Tirexs.Query


  test "boosting in general" do
    query = query do
      boosting do
        positive do
          match "value", "field"
        end
        negative do
          match "value", "field"
        end
      end
    end

    expected = [query: [boosting: [positive: [match: [value: [query: "field"]]], negative: [match: [value: [query: "field"]]]]]]
    assert query == expected
  end

  test "boobsting w/ options" do
    query = query do
      boosting negative_boost: 2 do
        positive do
          match "value", "field"
        end
        negative do
          match "value", "field"
        end
      end
    end

    expected = [query: [boosting: [positive: [match: [value: [query: "field"]]], negative: [match: [value: [query: "field"]]], negative_boost: 2]]]
    assert query == expected
  end
end
