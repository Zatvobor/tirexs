defmodule Tirexs.ElasticSearchTest do
  use ExUnit.Case

  import Tirexs.ElasticSearch

  test "default config" do
    assert make_url("articles", config) == "http://127.0.0.1:9200/articles"
  end

  test "key value config" do
    assert make_url("articles", config(
      scheme: "https",
      userinfo: "user:pass",
      host: "localhost",
      port: 9201
    )) == "https://user:pass@localhost:9201/articles"
  end

  test "url config" do
    assert make_url("articles", config("https://user:pass@localhost:9201"))
      == "https://user:pass@localhost:9201/articles"
  end
end
