defmodule Tirexs.Resources.DocumentTest do
  use ExUnit.Case

  alias Tirexs.Resources.Document


  test ~S| functions like a '_bulk()' | do
    actual = Document._bulk()
    assert actual == "_bulk"
  end

  test ~S| functions like a '_bulk("twitter")' | do
    actual = Document._bulk("twitter")
    assert actual == "twitter/_bulk"
  end

  test ~S| functions like a '_bulk("twitter", "tweet")' | do
    actual = Document._bulk("twitter", "tweet")
    assert actual == "twitter/tweet/_bulk"
  end

  test ~S| functions like a '_bulk("twitter", { [refresh: true] })' | do
    actual = Document._bulk("twitter", { [refresh: true] })
    assert actual == "twitter/_bulk?refresh=true"
  end

  test ~S| functions like a '_bulk("twitter", "tweet", { [refresh: true] })' | do
    actual = Document._bulk("twitter", "tweet", { [refresh: true] })
    assert actual == "twitter/tweet/_bulk?refresh=true"
  end

  test ~S| functions like a '_source("twitter/tweet/1")' | do
    actual = Document._source("twitter/tweet/1")
    assert actual == "twitter/tweet/1/_source"
  end

  test ~S| functions like a '_source("twitter/tweet/1", { [refresh: true] })' | do
    actual = Document._source("twitter/tweet/1", { [refresh: true] })
    assert actual == "twitter/tweet/1/_source?refresh=true"
  end

  test ~S| functions like a '_source("twitter", "tweet", "1")' | do
    actual = Document._source("twitter", "tweet", "1")
    assert actual == "twitter/tweet/1/_source"
  end

  test ~S| functions like a '_source("twitter", "tweet", "1", { [refresh: true] })' | do
    actual = Document._source("twitter", "tweet", "1", { [refresh: true] })
    assert actual == "twitter/tweet/1/_source?refresh=true"
  end

  @resources [ "doc", "index" ]

  test ~S| functions like a 'doc("twitter/tweet/1")' | do
    Enum.each @resources, fn(resource) ->
      # actual = Document.doc("twitter/tweet/1")
      actual = Kernel.apply(Document, String.to_atom(resource), ["twitter/tweet/1"])
      assert actual == "twitter/tweet/1"
    end
  end

  test ~S| functions like a 'doc("twitter/tweet", "1")' | do
    Enum.each @resources, fn(resource) ->
      # actual = Document.doc("twitter/tweet", "1")
      actual = Kernel.apply(Document, String.to_atom(resource), ["twitter/tweet", "1"])
      assert actual == "twitter/tweet/1"
    end
  end

  test ~S| functions like a 'doc("twitter/tweet", 1)' | do
    Enum.each @resources, fn(resource) ->
      # actual = Document.doc("twitter/tweet", 1)
      actual = Kernel.apply(Document, String.to_atom(resource), ["twitter/tweet", 1])
      assert actual == "twitter/tweet/1"
    end
  end

  test ~S| functions like a 'doc("twitter/tweet", "1", { [refresh: true] })' | do
    Enum.each @resources, fn(resource) ->
      # actual = Document.doc("twitter/tweet", "1", { [refresh: true] })
      actual = Kernel.apply(Document, String.to_atom(resource), ["twitter/tweet", "1", { [refresh: true] }])
      assert actual == "twitter/tweet/1?refresh=true"
    end
  end

  test ~S| functions like a 'doc("twitter/tweet/1", { [refresh: true] })' | do
    Enum.each @resources, fn(resource) ->
      # actual = Document.doc("twitter/tweet/1", { [refresh: true] })
      actual = Kernel.apply(Document, String.to_atom(resource), ["twitter/tweet/1", { [refresh: true] }])
      assert actual == "twitter/tweet/1?refresh=true"
    end
  end

  test ~S| functions like a 'doc("twitter", "tweet", "1")' | do
    Enum.each @resources, fn(resource) ->
      # actual = Document.doc("twitter", "tweet", "1")
      actual = Kernel.apply(Document, String.to_atom(resource), ["twitter", "tweet", "1"])
      assert actual == "twitter/tweet/1"
    end
  end

  test ~S| functions like a 'doc("twitter", "tweet", "1", { [refresh: true] })' | do
    Enum.each @resources, fn(resource) ->
      # actual = Document.doc("twitter", "tweet", "1", { [refresh: true] })
      actual = Kernel.apply(Document, String.to_atom(resource), ["twitter", "tweet", "1", { [refresh: true] }])
      assert actual == "twitter/tweet/1?refresh=true"
    end
  end
end
