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

  test ~S| functions like a '_validate_query("twitter")' | do
    actual = Search._validate_query("twitter")
    assert actual == "twitter/_validate/query"
  end

  test ~S| functions like a '_validate_query("twitter", "tweet")' | do
    actual = Search._validate_query("twitter", "tweet")
    assert actual == "twitter/tweet/_validate/query"
  end

  test ~S| functions like a '_validate_query("twitter", { [explain: true] })' | do
    actual = Search._validate_query("twitter", { [explain: true] })
    assert actual == "twitter/_validate/query?explain=true"
  end

  test ~S| functions like a '_validate_query("twitter", "tweet", { [explain: true] })' | do
    actual = Search._validate_query("twitter", "tweet", { [explain: true] })
    assert actual == "twitter/tweet/_validate/query?explain=true"
  end

  test ~S| functions like a '_count("twitter")' | do
    actual = Search._count("twitter")
    assert actual == "twitter/_count"
  end

  test ~S| functions like a '_count("twitter", "tweet")' | do
    actual = Search._count("twitter", "tweet")
    assert actual == "twitter/tweet/_count"
  end

  test ~S| functions like a '_count("twitter", { [lowercase_expanded_terms: true] })' | do
    actual = Search._count("twitter", { [lowercase_expanded_terms: true] })
    assert actual == "twitter/_count?lowercase_expanded_terms=true"
  end

  test ~S| functions like a '_count("twitter", "tweet", { [lowercase_expanded_terms: true] })' | do
    actual = Search._count("twitter", "tweet", { [lowercase_expanded_terms: true] })
    assert actual == "twitter/tweet/_count?lowercase_expanded_terms=true"
  end

  test ~S| functions like a '_search_exists("twitter")' | do
    actual = Search._search_exists("twitter")
    assert actual == "twitter/_search/exists"
  end

  test ~S| functions like a '_search_exists("twitter", "tweet")' | do
    actual = Search._search_exists("twitter", "tweet")
    assert actual == "twitter/tweet/_search/exists"
  end

  test ~S| functions like a '_search_exists("twitter/tweet", { [q: "user:kimchy"] })' | do
    actual = Search._search_exists("twitter/tweet", { [q: "user:kimchy"] })
    assert actual == "twitter/tweet/_search/exists?q=user%3Akimchy"
  end

  test ~S| functions like a '_search_exists("twitter", "tweet", { [q: "user:kimchy"] })' | do
    actual = Search._search_exists("twitter", "tweet", { [q: "user:kimchy"] })
    assert actual == "twitter/tweet/_search/exists?q=user%3Akimchy"
  end

  test ~S| functions like a '_search({ [q: "tag:wow"] })' | do
    actual = Search._search({ [q: "tag:wow"] })
    assert actual == "_search?q=tag%3Awow"
  end

  test ~S| functions like a '_search("twitter")' | do
    actual = Search._search("twitter")
    assert actual == "twitter/_search"
  end

  test ~S| functions like a '_search("twitter", "tweet")' | do
    actual = Search._search("twitter", "tweet")
    assert actual == "twitter/tweet/_search"
  end

  test ~S| functions like a '_search("twitter", ["tweet","user"])' | do
    actual = Search._search("twitter", ["tweet","user"])
    assert actual == "twitter/tweet,user/_search"
  end

  test ~S| functions like a '_search("twitter", ["tweet","user"], { [q: "user:kimchy"] })' | do
    actual = Search._search("twitter", ["tweet","user"], { [q: "user:kimchy"] })
    assert actual == "twitter/tweet,user/_search?q=user%3Akimchy"
  end

  test ~S| functions like a '_search("twitter/tweet", { [q: "user:kimchy"] })' | do
    actual = Search._search("twitter/tweet", { [q: "user:kimchy"] })
    assert actual == "twitter/tweet/_search?q=user%3Akimchy"
  end

  test ~S| functions like a '_search("twitter", "tweet", { [q: "user:kimchy"] })' | do
    actual = Search._search("twitter", "tweet", { [q: "user:kimchy"] })
    assert actual == "twitter/tweet/_search?q=user%3Akimchy"
  end

  test ~S| functions like a '_search_scroll()' | do
    actual = Search._search_scroll()
    assert actual == "_search/scroll"
  end

  test ~S| functions like a '_search_scroll({ [scroll_id: "c2Nhbjs2OzM0NDg1ODpzRlBLc0FXNlNyNm5JWUc1"] })' | do
    actual = Search._search_scroll({ [scroll_id: "c2Nhbjs2OzM0NDg1ODpzRlBLc0FXNlNyNm5JWUc1"] })
    assert actual == "_search/scroll?scroll_id=c2Nhbjs2OzM0NDg1ODpzRlBLc0FXNlNyNm5JWUc1"
  end

  test ~S| functions like a '_search_scroll("c2Nhbjs2OzM0NDg1ODpzRlBLc0FXNlNyNm5JWUc1")' | do
    actual = Search._search_scroll("c2Nhbjs2OzM0NDg1ODpzRlBLc0FXNlNyNm5JWUc1")
    assert actual == "_search/scroll/c2Nhbjs2OzM0NDg1ODpzRlBLc0FXNlNyNm5JWUc1"
  end

  test ~S| functions like a '_search_scroll_all()' | do
    actual = Search._search_scroll_all()
    assert actual == "_search/scroll/_all"
  end
end
