defmodule Tirexs.Resources.SearchTest do
  use ExUnit.Case

  alias Tirexs.Resources.Search


  test ~S| functions like a '_explain("twitter/tweet/1", { [q: "message:search"] })' | do
    actual = Search._explain("twitter/tweet/1", { [q: "message:search"] })
    assert actual == "twitter/tweet/1/_explain?q=message%3Asearch"
  end

  test ~S| functions like a '_explain("twitter", "tweet", "1", { [q: "message:search"] })' | do
    actual = Search._explain("twitter", "tweet", "1", { [q: "message:search"] })
    assert actual == "twitter/tweet/1/_explain?q=message%3Asearch"
  end

  test ~S| functions like a '_search_shards("twitter")' | do
    actual = Search._search_shards("twitter")
    assert actual == "twitter/_search_shards"
  end

  test ~S| functions like a '_search_shards("twitter", { [local: true] })' | do
    actual = Search._search_shards("twitter", { [local: true] })
    assert actual == "twitter/_search_shards?local=true"
  end

  test ~S| functions like a '_search_shards("twitter", "tweet", { [local: true] })' | do
    actual = Search._search_shards("twitter", "tweet", { [local: true] })
    assert actual == "twitter/tweet/_search_shards?local=true"
  end

  test ~S| functions like a '_search_shards("twitter", "tweet")' | do
    actual = Search._search_shards("twitter", "tweet")
    assert actual == "twitter/tweet/_search_shards"
  end

  test ~S| functions like a '_field_stats(["index1", "index2"])' | do
    actual = Search._field_stats(["index1", "index2"])
    assert actual == "index1,index2/_field_stats"
  end

  test ~S| functions like a '_field_stats("bear_test", { [fields: "rating"] })' | do
    actual = Search._field_stats("bear_test", { [fields: "rating"] })
    assert actual == "bear_test/_field_stats?fields=rating"
  end
end
