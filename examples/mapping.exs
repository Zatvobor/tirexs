#
# Run this example from console manually:
#
#   $ mix run -r examples/mapping.exs
#   # => curl -X PUT -d '{"dsl": {"properties": {"mn_opts_": {"type": "nested","properties": {"uk": {"type": "object","properties": {"credentials": {"type": "object","properties": {"available_from": {"type": "long"},"buy": {"type": "object"},"str": {"type": "object"}}}}}}},"rev_history_": {"type": "object"}}}}' http://127.0.0.1:9200/bear_test
#
# Run this example from Elixir environment (`iex -S mix`):
#
#   iex> Tirexs.Loader.load Path.expand("examples/mapping.exs")
#
settings = Tirexs.ElasticSearch.config(user: "kimchy")
Tirexs.ElasticSearch.delete("bear_test", settings)

Tirexs.DSL.define [type: "dsl", index: "bear_test"], fn(index, _) ->
  import Tirexs.Mapping

  mappings do
   indexes "mn_opts_", [type: "nested"] do
     indexes "uk", [type: "object"] do
       indexes "credentials", [type: "object"] do
         indexes "available_from", type: "long"
         indexes "buy", type: "object"
         indexes "str", type: "object"
       end
     end
   end

   indexes "rev_history_", type: "object"
  end

  # Below a couple of code lines which could be useful for debugging and getting actual JSON string

  # url  = Tirexs.ElasticSearch.make_url(index[:index], settings)
  # json = JSX.prettify!(Tirexs.Mapping.to_resource_json(index))
  # IO.puts "\n# => curl -X PUT -d '#{json}' #{url}"

  { index, settings }
end
