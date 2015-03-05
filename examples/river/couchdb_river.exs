#
# Run this example from console manually:
#
#   mix run -r examples/river/couchdb_river.exs
#   # => curl -X PUT -d '{"type":"couchdb","couchdb":{"ignore_attachments":true,"host":"localhost","port":5984,"db":"labeled","filter":"elastic/only","script":"ctx._type = ctx.doc.type"},"index":{"bulk_size":100,"bulk_timeout":"1ms","index":"test"}}' http://127.0.0.1:9200/_river/tets_river_dsl/_meta
#
# Run this example from Elixir environment:
#
#   Tirexs.Loader.load Path.expand("examples/river/couchdb_river.exs")
#
use Tirexs.River

Tirexs.DSL.define [name: "tets_river_dsl"], fn(river, elastic_settings) ->

  river [type: "couchdb"] do

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


  # Below a couple of code which could be useful for debugging
  # url  = Tirexs.ElasticSearch.make_url("_river/" <> river[:name] <>"/_meta", elastic_settings)
  # json = JSX.prettify!(Tirexs.River.to_resource_json(river))
  # IO.puts "\n # => curl -X PUT -d '#{json}' #{url}"

  { river, elastic_settings }
end
