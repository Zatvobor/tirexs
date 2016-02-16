defmodule Tirexs.HTTPTest do
  use ExUnit.Case

  import Tirexs.HTTP

  test "url/1 by 'http://example.com/articles/document/1'" do
    actual = url("http://example.com/articles/document/1")
    assert actual == "http://example.com/articles/document/1"
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

  test "url/1 by '%URI{ host: 'example.com', path: '/articles/document/1' }' and uri by default" do
    actual = url(%URI{ host: "example.com", path: "/articles/document/1", port: nil })
    assert actual == "http://example.com/articles/document/1"
  end

  test "url/2 by '/articles/document/1' and uri by default" do
    actual = url("/articles/document/1", Tirexs.get_uri_env())
    assert actual == "http://127.0.0.1:9200/articles/document/1"
  end

  test "url/2 by '/articles/document/1' and uri" do
    actual = url("/articles/document/1", %URI{ port: 92 })
    assert actual == "http://127.0.0.1:92/articles/document/1"
  end

  test "url/2 by 'articles' and uri by default" do
    actual = url("articles", Tirexs.get_uri_env())
    assert actual == "http://127.0.0.1:9200/articles"
  end

  test "url/2 by '%URI{ host: 'example.com', port: nil }' and uri by default" do
    actual = url("articles", %URI{ host: "example.com", port: nil })
    assert actual == "http://example.com/articles"
  end
end
