defmodule Tirexs.MultiGetTest do
  use ExUnit.Case

  import Tirexs.MultiGet


  @expected_string ~S'''
  {"ids":[1,2]}
  '''

  test "mget/0 for ids/1"  do
    actual = mget do
      ids([ 1, 2 ])
    end
    assert actual == @expected_string
  end

  test "ids/1" do
    actual = ids([ 1, 2 ])
    assert actual == [
      ids: [ 1, 2 ]
    ]
  end

  @expected_string ~S'''
  {"docs":[{"_id":1},{"_id":1}]}
  '''

  test "mget/0 for docs/1"  do
    actual = mget do
      docs([ [id: 1], [id: 1] ])
    end
    assert actual == @expected_string
  end

  test "docs/1" do
    actual = docs([ [id: 1], [id: 1] ])
    assert actual == [
      docs: [ [ _id: 1 ], [ _id: 1] ]
    ]
  end

  @expected_string ~S'''
  {"docs":[{"_index":"bear_test","_type":"bear_type","_id":1,"fields":[]},{"_index":"bear_test","_type":"bear_type","_id":2,"_source":false}]}
  '''

  test "mget/0 for docs/1 w/ index"  do
    actual = mget do
      docs([
        [ index: "bear_test", type: "bear_type", id: 1, fields: [] ],
        [ index: "bear_test", type: "bear_type", id: 2, source: false ]
      ])
    end
    assert actual == @expected_string
  end


  test "docs/1 w/ index" do
    actual = docs([
      [ index: "bear_test", type: "bear_type", id: 1, fields: [] ],
      [ index: "bear_test", type: "bear_type", id: 2, source: false ]
    ])
    assert actual == [
      docs: [
        [ _index: "bear_test", _type: "bear_type", _id: 1, fields: [] ],
        [ _index: "bear_test", _type: "bear_type", _id: 2, _source: false ]
      ]
    ]
  end
end
