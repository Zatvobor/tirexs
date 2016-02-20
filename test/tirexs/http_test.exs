defmodule Tirexs.HTTPTest do
  use ExUnit.Case

  import Tirexs.HTTP

  test "url/1 by 'http://example.com/articles/document/1'" do
    actual = url("http://example.com/articles/document/1")
    assert actual == "http://example.com/articles/document/1"
  end

  test "url/0 by default" do
    assert url() == "http://127.0.0.1:9200"
  end

  test "url/1 by uri default" do
    actual = url(Tirexs.get_uri_env())
    assert actual == "http://127.0.0.1:9200"
  end

  test "url/1 by '/articles/document/1' and uri by default" do
    actual = url("/articles/document/1")
    assert actual == "http://127.0.0.1:9200/articles/document/1"
  end

  test "url/1 by 'articles' and uri by default" do
    actual = url("articles")
    assert actual == "http://127.0.0.1:9200/articles"
  end

  test "url/1 by '%URI{ path: '/articles/document/1', port: 92 }' and uri by default" do
    actual = url(%URI{ path: "/articles/document/1", port: 92 })
    assert actual == "http://127.0.0.1:92/articles/document/1"
  end

  test "url/1 by '%URI{ path: 'articles', port: 92 }' and uri by default" do
    actual = url(%URI{ path: "articles", port: 92 })
    assert actual == "http://127.0.0.1:92/articles"
  end

  test "url/1 by '%URI{ host: 'example.com', path: '/articles/document/1' }' and uri by default" do
    actual = url(%URI{ host: "example.com", path: "/articles/document/1" })
    assert actual == "http://example.com:9200/articles/document/1"
  end

  test "url/2 by '/articles/document/1' and uri by default" do
    actual = url("/articles/document/1", Tirexs.get_uri_env())
    assert actual == "http://127.0.0.1:9200/articles/document/1"
  end

  test "url/2 by '/articles/document/1' and '%URI{ port: 92 }'" do
    actual = url("/articles/document/1", %URI{ port: 92 })
    assert actual == "http://127.0.0.1:92/articles/document/1"
  end

  test "url/2 by 'articles' and uri by default" do
    actual = url("articles", Tirexs.get_uri_env())
    assert actual == "http://127.0.0.1:9200/articles"
  end

  test "url/2 by 'articles' and '%URI{ host: 'example.com', port: 80 }'" do
    actual = url("articles", %URI{ host: "example.com", port: 80 })
    assert actual == "http://example.com/articles"
  end

  test "decode/1 {\"hello\":\"world\"}" do
    actual = decode("{\"hello\":\"world\"}")
    assert actual == %{hello: "world"}
  end

  test "decode/1 {\"hello\":\"world\"} as list" do
    actual = decode("{\"hello\":\"world\"}")
    assert Map.to_list(actual) == [hello: "world"]
  end

  test "decode/1 \"hello\"" do
    actual = decode("\"hello\"")
    assert actual == "hello"
  end

  test "encode/1 %{hello: \"world\"} as map" do
    actual = encode(%{hello: "world"})
    assert actual == "{\"hello\":\"world\"}"
  end

  test "encode/1 %{hello: 'world'} as map" do
    actual = encode(%{hello: 'world'})
    assert actual == "{\"hello\":[119,111,114,108,100]}"
  end

  test "encode/1 [hello: \"world\"] as list" do
    actual = encode([hello: "world"])
    assert actual == "{\"hello\":\"world\"}"
  end

  test "encode/1 []" do
    actual = encode([])
    assert actual == "[]"
  end

  test "encode/1 %{}" do
    actual = encode(%{})
    assert actual == "{}"
  end

  test "encode/1 \"hello\" as binary" do
    actual = encode("hello")
    assert actual == "\"hello\""
  end
end
