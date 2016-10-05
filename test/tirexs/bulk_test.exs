defmodule Tirexs.BulkTest do
  use ExUnit.Case

  import Tirexs.Bulk


  @expected_string ~S'''
  {"update":{"_index":"website","_type":"blog","_id":1,"_retry_on_conflict":3}}
  {"doc":{"title":"[updated] My first blog post"},"fields":["_source"]}
  {"update":{"_index":"website","_type":"blog","_id":2,"_retry_on_conflict":3}}
  {"doc":{"title":"[updated] My second blog post"},"doc_as_upsert":true}
  '''

  test "payload_as_string/0 example w/ single raw payload" do
    actual = payload_as_string do
      update [ index: "website", type: "blog"], [
        [
          doc: [id: 1, _retry_on_conflict: 3, title: "[updated] My first blog post"],
          fields: ["_source"],
        ],
        [
          doc: [id: 2, _retry_on_conflict: 3, title: "[updated] My second blog post"],
          doc_as_upsert: true,
        ]
      ]
    end
    assert actual == @expected_string
  end

  test "payload_as_string/1 example w/ single raw payload" do
    actual = payload_as_string([ index: "website", type: "blog" ]) do
      update [
        [
          doc: [id: 1, _retry_on_conflict: 3, title: "[updated] My first blog post"],
          fields: ["_source"],
        ],
        [
          doc: [id: 2, _retry_on_conflict: 3, title: "[updated] My second blog post"],
          doc_as_upsert: true,
        ]
      ]
    end
    assert actual == @expected_string
  end

  @expected_string ~S'''
  {"index":{"_index":"website","_type":"blog","_id":1,"_parent":123}}
  {"title":"My first blog post"}
  {"index":{"_index":"website","_type":"blog","_id":2,"_parent":321}}
  {"title":"My second blog post"}
  {"update":{"_index":"website","_type":"blog","_id":1,"_retry_on_conflict":3}}
  {"doc":{"title":"[updated] My first blog post"},"fields":["_source"]}
  {"update":{"_index":"website","_type":"blog","_id":2,"_retry_on_conflict":3}}
  {"doc":{"title":"[updated] My second blog post"},"doc_as_upsert":true}
  '''

  test "payload_as_string/0 example w/ raw payload" do
    actual = payload_as_string do
      index   [ index: "website", type: "blog" ], [
        [id: 1, title: "My first blog post", _parent: 123],
        [id: 2, title: "My second blog post", _parent: 321]
      ]
      update  [ index: "website", type: "blog"], [
        [
          doc:    [id: 1, _retry_on_conflict: 3, title: "[updated] My first blog post"],
          fields: ["_source"],
        ],
        [
          doc:           [id: 2, _retry_on_conflict: 3, title: "[updated] My second blog post"],
          doc_as_upsert: true,
        ]
      ]
    end
    assert actual == @expected_string
  end

  test "payload_as_string/1 example w/ raw payload" do
    actual = payload_as_string([ index: "website", type: "blog" ]) do
      index [
        [id: 1, title: "My first blog post", _parent: 123],
        [id: 2, title: "My second blog post", _parent: 321]
      ]
      update [
        [
          doc: [id: 1, _retry_on_conflict: 3, title: "[updated] My first blog post"],
          fields: ["_source"],
        ],
        [
          doc: [id: 2, _retry_on_conflict: 3, title: "[updated] My second blog post"],
          doc_as_upsert: true,
        ]
      ]
    end
    assert actual == @expected_string
  end

  @expected_list [
    [ index: [ _index: "website", _type: "blog", _id: 1 ]],
    [ title: "My first blog post" ],
    [ index: [ _index: "website", _type: "blog", _id: 2 ]],
    [ title: "My second blog post" ],
  ]

  test "payload_as_list/0 example w/ single raw payload" do
    actual = payload_as_list do
      index [ index: "website", type: "blog" ], [
        [id: 1, title: "My first blog post"],
        [id: 2, title: "My second blog post"]
      ]
    end
    assert actual == @expected_list
  end

  test "payload_as_list/1 example w/ single raw payload" do
    actual = payload_as_list([ index: "website", type: "blog" ]) do
      index [
        [id: 1, title: "My first blog post"],
        [id: 2, title: "My second blog post"]
      ]
    end
    assert actual == @expected_list
  end

  @expected_list [
    [ index: [ _index: "website", _type: "blog", _id: 1 ]],
    [ title: "My first blog post" ],
    [ index: [ _index: "website", _type: "blog", _id: 2 ]],
    [ title: "My second blog post" ],
    [ update: [ _index: "website", _type: "blog", _id: 1, _retry_on_conflict: 3 ]],
    [ doc:    [ title: "[updated] My first blog post" ], fields: ["_source"]],
    [ update: [ _index: "website", _type: "blog", _id: 2, _retry_on_conflict: 3 ]],
    [ doc:    [ title: "[updated] My second blog post" ], doc_as_upsert: true ]
  ]

  test "payload_as_list/0 example w/ raw payload" do
    actual = payload_as_list do
      index   [ index: "website", type: "blog" ], [
        [id: 1, title: "My first blog post"],
        [id: 2, title: "My second blog post"]
      ]
      update  [ index: "website", type: "blog"], [
        [
          doc: [id: 1, _retry_on_conflict: 3, title: "[updated] My first blog post"],
          fields: ["_source"],
        ],
        [
          doc: [id: 2, _retry_on_conflict: 3, title: "[updated] My second blog post"],
          doc_as_upsert: true,
        ]
      ]
    end
    assert actual == @expected_list
  end

  test "payload_as_list/1 example w/ raw payload" do
    actual = payload_as_list([ index: "website", type: "blog" ]) do
      index [
        [id: 1, title: "My first blog post"],
        [id: 2, title: "My second blog post"]
      ]
      update [
        [
          doc: [id: 1, _retry_on_conflict: 3, title: "[updated] My first blog post"],
          fields: ["_source"],
        ],
        [
          doc: [id: 2, _retry_on_conflict: 3, title: "[updated] My second blog post"],
          doc_as_upsert: true,
        ]
      ]
    end
    assert actual == @expected_list
  end

  test "delete/2" do
    actual = delete([a: "a"], [[id: "i"], [id: "i"]])
    assert actual == [
      [delete: [_a: "a", _id: "i"]],
      [delete: [_a: "a", _id: "i"]]
    ]
  end

  test "delete/1" do
    actual = delete([[id: "i"], [id: "i"]])
    assert actual == [
      [delete: [_id: "i"]],
      [delete: [_id: "i"]]
    ]
  end

  test "index/2" do
    actual = index([a: "a"], [[id: "i", f: "f"], [id: "i", f: "f"]])
    assert actual == [
      [index: [_a: "a", _id: "i"]],
      [f: "f"],
      [index: [_a: "a", _id: "i"]],
      [f: "f"]
    ]
  end

  test "index/1" do
    actual = index([[id: "i", f: "f"], [id: "i", f: "f"]])
    assert actual == [
      [index: [_id: "i"]],
      [f: "f"],
      [index: [_id: "i"]],
      [f: "f"]
    ]
  end

  test "create/2" do
    actual = create([a: "a"], [[id: "i", f: "f"]])
    assert actual == [
      [create: [_a: "a", _id: "i"]],
      [f: "f"]
    ]
  end

  test "create/1" do
    actual = create([[id: "i", f: "f"]])
    assert actual == [
      [create: [_id: "i"]],
      [f: "f"]
    ]
  end

  test "update/2" do
    actual = update([a: "a"], [ [doc: [id: "i", field: "f"], fields: ["f"]], [doc: [id: "i", field: "f"], fields: ["f"]]])
    assert actual == [
      [update: [_a: "a", _id: "i"]],
      [doc: [field: "f"], fields: ["f"]],
      [update: [_a: "a", _id: "i"]],
      [doc: [field: "f"], fields: ["f"]]
    ]
  end

  test "update/1" do
    actual = update([[doc: [id: "i", field: "f"], fields: ["f"]], [doc: [id: "i", field: "f"], fields: ["f"]]])
    assert actual == [
      [update: [_id: "i"]],
      [doc: [field: "f"], fields: ["f"]],
      [update: [_id: "i"]],
      [doc: [field: "f"], fields: ["f"]]
    ]
  end

  test "get_id_from_document/1" do
    document = [id: 1, title: "Hello"]
    assert get_id_from_document(document) == 1

    document = [{:id, 1}, {:title, "Hello"}]
    assert get_id_from_document(document) == 1

    document = [_id: 1, title: "Hello"]
    assert get_id_from_document(document) == 1

    document = [{:_id, 1}, {:title, "Hello"}]
    assert get_id_from_document(document) == 1
  end

  test "get_type_from_document/1" do
    document = [id: 1, title: "Hello", type: "my_type"]
    assert get_type_from_document(document) == "my_type"
  end
end
