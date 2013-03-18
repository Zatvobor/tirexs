#
# Run this example from console manually:
#
#   mix run -r examples/search.exs
# Run this example from Elixir environment:
# => curl -X POST -d '{"query":{"nested":{"query":{"bool":{"must":[{"match":{"comments.author":{"query":"John"}}},{"match":{"comments.message":{"query":"cool"}}}]}},"path":"comments"}}}' http://127.0.0.1:9200/tets_index/_search
#
#   Tirexs.Loader.load Path.expand("examples/search.exs")
#


import Tirexs.Search

Tirexs.DSL.define fn(_elastic_settings) ->
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

  # This couple of code lines here just for `mix run -r examples/search.exs` command output
  # It's obvious that you should not use it in real search :)
  url  = Tirexs.ElasticSearch.make_url(search[:index] <> "/_search", _elastic_settings)
  json = Tirexs.Query.to_resource_json(search)
  IO.puts "# => curl -X POST -d '#{json}' #{url}"

  { search, _elastic_settings }
end