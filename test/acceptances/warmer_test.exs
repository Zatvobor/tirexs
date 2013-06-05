Code.require_file "../../test_helper.exs", __FILE__
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

    Tirexs.ElasticSearch.put("bear_test", JSEX.encode!(warmers), settings)
    {_, _, body} = Tirexs.ElasticSearch.get("bear_test/my_type/_warmer/warmer_1", settings)

    assert body["bear_test"]["warmers"] == [{"warmer_1",[{"types",[]},{"source",[{"query",[{"match_all",[]}]},{"facets",[{"facet_1",[{"terms",[{"field","field"}]}]}]}]}]}]
    Tirexs.ElasticSearch.delete("bear_test", settings)
  end
end