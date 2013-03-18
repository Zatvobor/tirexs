[![Build Status](https://travis-ci.org/datahogs/tirexs.png)](https://travis-ci.org/datahogs/tirexs)

tirexs
======

A DSL for the ElasticSearch search engine. Inspired by amazing https://github.com/karmi/tire gem
Let's create an index named articles and store/index some documents:

    settings = Tirexs.ElasticSearch.Config.new()

    Tirexs.Bulk.store [index: "articles", refresh: true], settings do
      create id: 1, title: "One", tags: ["elixir"], type: "article"
      create id: 2, title: "Two", tags: ["elixir", "ruby"], type: "article"
      create id: 3, title: "Three", tags: ["java"], type: "article"
      create id: 4, title: "Four", tags: ["erlang"], type: "article"
    end

We can also create the index with custom mapping for a specific document type:
    import Tirexs.Mapping

    settings = Tirexs.ElasticSearch.Config.new()

    index = [index: "articles", type: "article"]
    mappings do
      indexes "id", type: "string", index: "not_analyzed", include_in_all: false
      indexes "title", type: "string", boost: 2.0, analyzer: "snowball"
      indexes "tags",  type: "string", analyzer: "keyword"
      indexes "content", type: "string", analyzer: "snowball"
      indexes "authors", [type: "object"] do
        indexes "name", type: "string"
        indexes "nick_name", type: "string"
      end
    end

    [_, _, body] = Tirexs.Mapping.create_resource(index, settings)

For delete index:

    settings = Tirexs.ElasticSearch.Config.new()
    Tirexs.ElasticSearch.delete("articles", settings)

OK. Now, let's go search all the data.
We will be searching for articles whose title begins with letter “T”, sorted by title in descending order, filtering them for ones tagged “elixir”, and also retrieving some facets:
    import Tirexs.Search
    settings = Tirexs.ElasticSearch.Config.new()
    s = search [index: "articles"] do
      query do
        query_string "title:T*"
      end

      filter do
        terms "tags", ["elixir", "ruby"]
      end

      facets do
        global_tags [global: true] do
          terms field: "tags"
        end

        current_tags do
          terms field: "tags"
        end
      end
    end

    [_, _, result] = Tirexs.Query.create_resource(s, settings)

Let's display the results:
    Enum.each result["hits"]["hits"], fn(item) ->
      IO.puts inspect(item)
    end

     #=> [{"_index","articles"},{"_type","article"},{"_id","2"},{"_score",1.0},{"_source",[{"id",2},
     {"title","Two"},{"tags",["elixir","r uby"]},{"type","article"}]}]

License
-------

`Tirexs` source code is released under Apache 2 License.
Check [LICENSE](https://github.com/datahogs/tirexs/blob/master/LICENSE) and [NOTICE](https://github.com/datahogs/tirexs/blob/master/NOTICE) files for more details.

