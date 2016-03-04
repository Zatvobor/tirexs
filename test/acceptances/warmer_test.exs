defmodule Acceptances.WarmerTest do
  use ExUnit.Case


  alias Tirexs.{HTTP}


  setup do
    HTTP.delete("bear_test") && :ok
  end

  import Tirexs.Search.Warmer

  test :create_warmer do
    warmers = warmers do
      warmer_1 [types: []] do
        source do
          query do
            match_all
          end
          facets do
            facet_1 do
              terms field: "field"
            end
          end
        end
      end
    end

    HTTP.put!("bear_test", warmers)
    {:ok, 200, body} = HTTP.get("bear_test/_warmer/warmer_1")
    assert Dict.get(body, :bear_test) |> Dict.get(:warmers) == %{warmer_1: %{types: [], source: %{query: %{match_all: []}, facets: %{facet_1: %{terms: %{field: "field"}}}}}}
  end
end
