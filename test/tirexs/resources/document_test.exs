defmodule Tirexs.Resources.DocumentTest do
  use ExUnit.Case

  alias Tirexs.Resources.Document


  @resources [ "_bulk", "_mget" ]

  test ~S| functions like a '_bulk()' | do
    Enum.each @resources, fn(resource) ->
      # actual = Document._bulk()
      actual = Kernel.apply(Document, String.to_atom(resource), [])
      assert actual == "#{resource}"
    end
  end

  test ~S| functions like a '_bulk("twitter")' | do
    Enum.each @resources, fn(resource) ->
      # actual = Document._bulk("twitter")
      actual = Kernel.apply(Document, String.to_atom(resource), ["twitter"])
      assert actual == "twitter/#{resource}"
    end
  end

  test ~S| functions like a '_bulk("twitter/tweet")' | do
    Enum.each @resources, fn(resource) ->
      # actual = Document._bulk("twitter/tweet")
      actual = Kernel.apply(Document, String.to_atom(resource), ["twitter/tweet"])
      assert actual == "twitter/tweet/#{resource}"
    end
  end

  test ~S| functions like a '_bulk("twitter/tweet", { [refresh: true] })' | do
    Enum.each @resources, fn(resource) ->
      # actual = Document._bulk("twitter/tweet", { [refresh: true] })
      actual = Kernel.apply(Document, String.to_atom(resource), ["twitter/tweet", { [refresh: true] }])
      assert actual == "twitter/tweet/#{resource}?refresh=true"
    end
  end

  test ~S| functions like a '_bulk("twitter", "tweet")' | do
    Enum.each @resources, fn(resource) ->
      # actual = Document._bulk("twitter", "tweet")
      actual = Kernel.apply(Document, String.to_atom(resource), ["twitter", "tweet"])
      assert actual == "twitter/tweet/#{resource}"
    end
  end

  test ~S| functions like a '_bulk("twitter", "tweet", { [refresh: true] })' | do
    Enum.each @resources, fn(resource) ->
      # actual = Document._bulk("twitter", "tweet", { [refresh: true] })
      actual = Kernel.apply(Document, String.to_atom(resource), ["twitter", "tweet", { [refresh: true] }])
      assert actual == "twitter/tweet/#{resource}?refresh=true"
    end
  end

  @resources [ "_source", "_update" ]

  test ~S| functions like a '_source("twitter/tweet/1")' | do
    Enum.each @resources, fn(resource) ->
      # actual = Document._source("twitter/tweet/1")
      actual = Kernel.apply(Document, String.to_atom(resource), ["twitter/tweet/1"])
      assert actual == "twitter/tweet/1/#{resource}"
    end
  end

  test ~S| functions like a '_source("twitter/tweet/1", { [refresh: true] })' | do
    Enum.each @resources, fn(resource) ->
      # actual = Document._source("twitter/tweet/1", { [refresh: true] })
      actual = Kernel.apply(Document, String.to_atom(resource), ["twitter/tweet/1", { [refresh: true] }])
      assert actual == "twitter/tweet/1/#{resource}?refresh=true"
    end
  end

  test ~S| functions like a '_source("twitter", "tweet", "1")' | do
    Enum.each @resources, fn(resource) ->
      # actual = Document._source("twitter", "tweet", "1")
      actual = Kernel.apply(Document, String.to_atom(resource), ["twitter", "tweet", "1"])
      assert actual == "twitter/tweet/1/#{resource}"
    end
  end

  test ~S| functions like a '_source("twitter", "tweet", 1)' | do
    Enum.each @resources, fn(resource) ->
      # actual = Document._source("twitter", "tweet", 1)
      actual = Kernel.apply(Document, String.to_atom(resource), ["twitter", "tweet", 1])
      assert actual == "twitter/tweet/1/#{resource}"
    end
  end

  test ~S| functions like a '_source("twitter", "tweet", "1", { [refresh: true] })' | do
    Enum.each @resources, fn(resource) ->
      # actual = Document._source("twitter", "tweet", "1", { [refresh: true] })
      actual = Kernel.apply(Document, String.to_atom(resource), ["twitter", "tweet", "1", { [refresh: true] }])
      assert actual == "twitter/tweet/1/#{resource}?refresh=true"
    end
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
