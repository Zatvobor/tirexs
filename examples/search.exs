#
# Run this example from console manually:
#
#   mix run -r examples/search.exs
#   # => curl -X POST -d '{"query":{"nested":{"query":{"bool":{"must":[{"match":{"comments.author":{"query":"John"}}},{"match":{"comments.message":{"query":"cool"}}}]}},"path":"comments"}}}' http://127.0.0.1:9200/tets_index/_search
#
# Run this example from Elixir environment:
#
#   Tirexs.Loader.load Path.expand("examples/search.exs")
#
import Tirexs.Search

Tirexs.DSL.define fn(elastic_settings) ->
  # We'll use the `nested` query to search for articles where _John_ left a _"Cool"_ message:
  #
  search = search [index: "articles"] do
    query do
      nested [path: "comments"] do
        query do
          bool do
            must do
              match "comments.author",  "John"
              match "comments.message", "cool"
            end
          end
        end
      end
    end
  end

  # Below a couple of code which could be useful for debugging
  # url  = Tirexs.ElasticSearch.make_url(search[:index] <> "/_search", elastic_settings)
  # json = JSX.prettify!(Tirexs.Query.to_resource_json(search))
  # IO.puts "\n # => curl -X POST -d '#{json}' #{url}"

  { search, elastic_settings }
end