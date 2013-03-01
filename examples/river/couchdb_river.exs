use Tirexs.River

Tirexs.DSL.define [name: "tets_river_dsl"], fn(river, elastic_settings) ->

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

  [river, elastic_settings]
end