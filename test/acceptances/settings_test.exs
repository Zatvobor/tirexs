defmodule Acceptances.SettingsTest do
  use ExUnit.Case

  import Tirexs.Index.Settings
  alias Tirexs.{HTTP}

  setup_all do
    HTTP.delete("bear_test") && :ok
  end

  test "create settings" do
    index_name = "bear_test"
    index = [index: index_name]
    settings do
      analysis do
        analyzer "autocomplete_analyzer",
        [
          filter: ["lowercase", "asciifolding"],
          tokenizer: "whitespace"
        ]
      end
    end

    {:ok, _, body} = Tirexs.ElasticSearch.Settings.create_resource(index)
    assert body[:acknowledged] == true

    {:ok, _, body} = Tirexs.bump()._settings(index_name)
    assert Map.has_key?(body[String.to_atom(index_name)][:settings][:index], :analysis)
  end
end
