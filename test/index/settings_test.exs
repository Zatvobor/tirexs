Code.require_file "../../test_helper.exs", __FILE__

defmodule SettingsTest do
  use ExUnit.Case
  import Tirexs
  use Tirexs.Index.Settings

  test :simpe_index_settings do
    index = create_index([name: "bear_test"])

    settings do
      filters do
        filter "suggestions_shingle", [type: "shingle", min_shingle_size: 2, max_shingle_size: 5]
      end

      analysis do
      end

      blocks do
      end

      cache do
      end

      index refresh_interval: 2

    end
    assert index[:settings] == [index: [cache: [], blocks: []], analysis: []]
  end
end