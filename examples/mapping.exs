use Tirexs.Mapping

Tirexs.DSL.mapping [type: "dsl", name: "test_dsl_index"], fn(index, elastic_settings) ->
  #for delete exist mapping use
  # delete(elastic_settings, "test_dsl_index/dsl")
  elastic_settings = elastic_settings.new([uri: "localhost", user: "new_user"])
   mappings do
     indexes "mn_opts_", [type: "nested"] do
       indexes "uk", [type: "nested"] do
         indexes "credentials", [type: "nested"] do
           indexes "available_from", type: "long"
           indexes "buy", type: "nested"
           indexes "str", type: "nested"
         end
       end
     end

     indexes "rev_history_", type: "nested"
   end
   [index, elastic_settings]
end