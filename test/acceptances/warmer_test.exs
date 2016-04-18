defmodule Acceptances.WarmerTest do
  use ExUnit.Case


  alias Tirexs.{HTTP}


  setup do
    HTTP.delete("bear_test") && :ok
  end

  import Tirexs.Search.Warmer

  test "index warmers" do
    warmers = warmers do
      warmer_1 [types: []] do
        source do
          query do
            match_all
          end
          aggs do
            agg_name do
              terms [field: "gender"]
            end
          end
        end
      end
    end

    HTTP.put!("bear_test", warmers)
    {:ok, 200, %{bear_test: %{warmers: %{warmer_1: actual }}}} = HTTP.get("bear_test/_warmer/warmer_1")

    expected = %{source: %{aggs: %{agg_name: %{terms: %{field: "gender"}}}, query: %{match_all: []}}, types: []}
    assert actual == expected
  end
end
