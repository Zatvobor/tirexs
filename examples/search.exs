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

Tirexs.DSL.define [index: "tets_index"], fn(_search, elastic_settings) ->
  # Let's consider the `nested` query for searching articles where user `John` has left a `Cool` message:
  search = search do
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

  # This couple of code lines here just for `mix run -r examples/search.exs` command output
  # It's obvious that you should not use it in real search :)
  url  = Tirexs.ElasticSearch.make_url(_search[:index] <> "/_search", elastic_settings)
  json = Tirexs.Query.to_resource_json(search)
  IO.puts "# => curl -X POST -d '#{json}' #{url}"

  { search ++ _search, elastic_settings }
end