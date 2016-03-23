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


  @tag skip: "deprecated in 1.6.0 and removed in 2.0"
  test :more_like_this do
    Tirexs.Bulk.store [index: "bear_test", refresh: false], @settings do
      create id: 1, name: "bar1", description: "foo bar test", type: "my_type"
      create id: 2, name: "bar2", description: "foo bar test", type: "my_type"
    end

    Tirexs.Manage.refresh(["bear_test"], @settings)

    {:ok, _, body} = Tirexs.Manage.more_like_this([id: 1, type: "my_type", index: "bear_test", mlt_fields: "name,description", min_term_freq: 1], @settings)
    assert Dict.get(body, :hits) |> Dict.get(:hits) == []
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
