Code.require_file "../../test_helper.exs", __ENV__.file

defmodule Acceptances.ManageTest do
  use ExUnit.Case
  import TestHelpers

  import Tirexs.Bulk

  require Tirexs.ElasticSearch

  @settings Tirexs.ElasticSearch.config()

  setup do
    create_index("bear_test", @settings)

    on_exit fn ->
      remove_index("bear_test", @settings)
      :ok
    end

    :ok
  end

  test :update do
    Tirexs.ElasticSearch.put("bear_test/my_type", @settings)
    doc = [user: "kimchy", counter: 1, post_date: "2009-11-15T14:12:12", message: "trying out Elastic Search", id: 1]

    Tirexs.ElasticSearch.put("bear_test/my_type/1", JSX.encode!(doc), @settings)

    update = [doc: [name: "new_name"]]
    Tirexs.Manage.update([index: "bear_test", type: "my_type", id: "1"], update, @settings)
    {_, _, body} = Tirexs.ElasticSearch.get("bear_test/my_type/1", @settings)

    assert body[:_source][:name] == "new_name"
  end
end
