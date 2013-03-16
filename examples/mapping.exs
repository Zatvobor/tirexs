#
# Run this example from console manually:
#
#   mix run -r examples/mapping.exs
#   # => curl -X PUT -d '{"dsl":{"properties":{"mn_opts_":{"type":"nested","properties":{"uk":{"type":"object","properties":{"credentials":{"type":"object","properties":{"available_from":{"type":"long"},"buy":{"type":"object"},"str":{"type":"object"}}}}}}},"rev_history_":{"type":"object"}}}}' http://127.0.0.1:9200/test_dsl_index
#
# Run this example from Elixir environment:
#
#   Tirexs.Loader.load Path.expand("examples/mapping.exs")
#
use Tirexs.Mapping

Tirexs.DSL.define [type: "dsl", index: "test_dsl_index"], fn(index, _elastic_settings) ->

  elastic_settings = Tirexs.ElasticSearch.Config.new([user: "new_user"])

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

   # This couple of code lines here just for `mix run -r examples/mapping.exs` command output
   # It's obvious that you should not use it in real mappings :)
   url  = Tirexs.ElasticSearch.make_url(index[:index], elastic_settings)
   json = Tirexs.Mapping.to_resource_json(index)
   IO.puts "# => curl -X PUT -d '#{json}' #{url}"

   { index, elastic_settings }
end