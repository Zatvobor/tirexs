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
end
