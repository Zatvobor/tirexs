Code.require_file "../../test_helper.exs", __FILE__
defmodule River.CouchDb.Test do
  use ExUnit.Case
  import Tirexs
  use Tirexs.River

  test :river do
    river = init_river(name: "test_river")
    river do
      type "couchdb"

      couchdb do
        [
          ignore_attachments: true,
          host: "localhost",
          port: 5984,
          db: "labeled",
          filter: "elastic/only",
          script: "ctx._type = ctx.doc.type"
        ]
      end

      index do
        [
          bulk_size: 100,
          bulk_timeout: "1ms",
          index: "test"
        ]
      end

    end

    assert river[:name] == "test_river"
    assert river[:type] == "couchdb"
    assert river[:index] == [bulk_size: 100, bulk_timeout: "1ms", index: "test"]
    assert river[:couchdb] == [ignore_attachments: true, host: "localhost", port: 5984, db: "labeled", filter: "elastic/only", script: "ctx._type = ctx.doc.type"]
  end

end