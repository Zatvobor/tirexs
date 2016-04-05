Code.require_file "../../test_helper.exs", __ENV__.file

defmodule Acceptances.BulkTest do
  use ExUnit.Case
  import Tirexs.Bulk
  require Tirexs.ElasticSearch

  test :create do
    settings = Tirexs.ElasticSearch.config()

        Tirexs.ElasticSearch.delete("bear_test", settings)

        Tirexs.Bulk.store [index: "bear_test", refresh: false], settings do
          create id: 1, title: "bar1", description: "foo bar test"
          create id: 2, title: "bar2", description: "foo bar test"
          create id: 3, title: "bar3", description: "foo bar test"
          create id: 4, title: "bar4", description: "foo bar test"
          create id: 5, title: "bar5", description: "foo bar test"
          create id: 6, title: "bar6", description: "foo bar test"
          create id: 7, title: "bar7", description: "foo bar test"
          create id: 8, title: "bar8", description: "foo bar test"
          create id: 9, title: "bar9", description: "foo bar test"
          create id: 10, title: "bar10", description: "foo bar test"
          create id: 11, title: "bar11", description: "foo bar test"
          delete id: 11
          index  id: 90, title: "barww"
        end

        Tirexs.Manage.refresh("bear_test", settings)
        {_, _, body} = Tirexs.ElasticSearch.get("bear_test/_count", settings)
        assert body[:count] == 11
  end

  test :update do
    settings = Tirexs.ElasticSearch.config()
      Tirexs.ElasticSearch.delete("bear_test", settings)

    Tirexs.Bulk.store [index: "bear_test", refresh: false], settings do
        create id: 1, title: "bar1", description: "foo bar test"
        create id: 2, title: "bar2", description: "foo bar test"
    end

    Tirexs.Manage.refresh("bear_test", settings)
    {_, _, body} = Tirexs.ElasticSearch.get("bear_test/_count", settings)
    assert body[:count] == 2

    # Test update
    updated_title = "updated_title"
    Tirexs.Bulk.store [index: "bear_test", type: "document", retry_on_conflict: 3], settings do
      update [id: 1, title: updated_title]
    end

    Tirexs.Manage.refresh("bear_test", settings)
    {_, _, %{_source: %{title: title}}} = Tirexs.ElasticSearch.get("bear_test/document/1", settings)
    assert title == updated_title

    # Test multiple update
    updated_title = "updated_title"
    Tirexs.Bulk.store [index: "bear_test", type: "document", retry_on_conflict: 3], settings do
      update [id: 1, title: updated_title]
      update [id: 2, title: updated_title]
    end

    Tirexs.Manage.refresh("bear_test", settings)
    {_, _, %{_source: %{title: title}}} = Tirexs.ElasticSearch.get("bear_test/document/1", settings)
    assert title == updated_title
    {_, _, %{_source: %{title: title}}} = Tirexs.ElasticSearch.get("bear_test/document/2", settings)
    assert title == updated_title

    # Test upsert
    Tirexs.Bulk.store [index: "bear_test", type: "document", retry_on_conflict: 3], settings do
      update [id: 3, title: "updated_title"], upsert: true
    end

    Tirexs.Manage.refresh("bear_test", settings)
    {_, _, body} = Tirexs.ElasticSearch.get("bear_test/_count", settings)
    assert body[:count] == 3

    # Test no upsert
    Tirexs.Bulk.store [index: "bear_test", type: "document", retry_on_conflict: 3], settings do
      update [id: 4, title: "updated_title"]
    end

    Tirexs.Manage.refresh("bear_test", settings)
    {_, _, body} = Tirexs.ElasticSearch.get("bear_test/_count", settings)
    assert body[:count] == 3

    {_, _, _body} = Tirexs.ElasticSearch.get("bear_test/document/1", settings)
  end
end
