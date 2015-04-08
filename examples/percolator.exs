#
# Run this example from console manually:
#
#   $ mix run -r examples/percolator.exs
#   # => curl -X PUT -d '{"query": {"term": {"field1": "value1"}}}' http://127.0.0.1:9200/test/.percolator/1
#
# Run this example from Elixir environment (`iex -S mix`):
#
#   iex> Tirexs.Loader.load Path.expand("examples/percolator.exs")
#
import Tirexs.Percolator

Tirexs.DSL.define fn(settings) ->
  query = percolator [index: "test", name: "1"] do
    query do
      term "field1", "value1"
    end
  end

  # Below a couple of code lines which could be useful for debugging and getting actual JSON string

  # url  = Tirexs.ElasticSearch.make_url("test/.percolator/1", settings)
  # json = JSX.prettify!(Tirexs.Percolator.to_resource_json(query))
  # IO.puts "\n# => curl -X PUT -d '#{json}' #{url}"

  { [percolator: query], settings }
end
