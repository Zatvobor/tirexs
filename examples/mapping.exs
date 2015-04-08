#
# Run this example from console manually:
#
#   $ mix run -r examples/mapping.exs
#   # => curl -X PUT -d '{"dsl": {"properties": {"mn_opts_": {"type": "nested","properties": {"uk": {"type": "object","properties": {"credentials": {"type": "object","properties": {"available_from": {"type": "long"},"buy": {"type": "object"},"str": {"type": "object"}}}}}}},"rev_history_": {"type": "object"}}}}' http://127.0.0.1:9200/test_dsl_index
#
# Run this example from Elixir environment (`iex -S mix`):
#
#   iex> Tirexs.Loader.load Path.expand("examples/mapping.exs")
#
import Tirexs.Mapping
require Tirexs.ElasticSearch

settings = Tirexs.ElasticSearch.config(user: "new_user")

Tirexs.ElasticSearch.delete("test_dsl_index", settings)

Tirexs.DSL.define [type: "dsl", index: "test_dsl_index"], fn(index, _) ->

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
