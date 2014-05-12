Code.require_file "../../test_helper.exs", __ENV__.file
defmodule Acceptances.WarmerTest do
  use ExUnit.Case
  import Tirexs.Search.Warmer

  test :create_warmer do
    settings = Tirexs.ElasticSearch.Config.new()
    Tirexs.ElasticSearch.delete("bear_test", settings)

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

    IO.puts JSEX.encode!(warmers)
    Tirexs.ElasticSearch.put("bear_test", JSEX.encode!(warmers), settings)
    {:ok, 200, body} = Tirexs.ElasticSearch.get("bear_test/_warmer/warmer_1", settings)

    assert Dict.get(body, "bear_test") |> Dict.get("warmers") == [{"warmer_1",[{"types",[]},{"source",[{"query",[{"match_all",[]}]},{"facets",[{"facet_1",[{"terms",[{"field","field"}]}]}]}]}]}]
    Tirexs.ElasticSearch.delete("bear_test", settings)
  end
end
