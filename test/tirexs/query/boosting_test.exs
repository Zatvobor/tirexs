Code.require_file "../../../test_helper.exs", __FILE__
defmodule Tirexs.Query.Bool.Boosting.Test do
  use ExUnit.Case
  import Tirexs.Query


  test :boosting do
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
    assert query == [query: [boosting: [positive: [match: [value: [query: "field"]]], negative: [match: [value: [query: "field"]]]]]]
  end

  test :boosting_with_opts do
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
    assert query == [query: [boosting: [positive: [match: [value: [query: "field"]]], negative: [match: [value: [query: "field"]]], negative_boost: 2]]]
  end
end