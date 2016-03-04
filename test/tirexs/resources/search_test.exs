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
end
