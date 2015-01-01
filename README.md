https://github.com/roundscope/tirexs
[![Build Status](https://travis-ci.org/roundscope/tirexs.png)](https://travis-ci.org/roundscope/tirexs)

tirexs
======

An Elixir based DSL for operating the ElasticSearch cluster related stuff, such as indexes, scoped queries and so on.

releases:

- `v0.5.0` tested on elastcisearch `1.4.2`, elixir `1.0.2`
- `v0.5.0` tested on elastcisearch `1.1.1`, elixir `0.13.1`
- `v0.4` tested on elasticsearch `0.90.3`, elixir `0.12.5`

Walk-through a code
-------------------

Let's define the mapping for specific document type:

```elixir
import Tirexs.Mapping

index = [index: "articles", type: "article"]
mappings do
  indexes "id", type: "long", index: "not_analyzed", include_in_all: false
  indexes "title", type: "string", boost: 2.0, analyzer: "snowball"
  indexes "tags",  type: "string", analyzer: "keyword"
  indexes "content", type: "string", analyzer: "snowball"
  indexes "authors", [type: "object"] do
    indexes "name", type: "string"
    indexes "nick_name", type: "string"
  end
end

{ :ok, status, body } = Tirexs.Mapping.create_resource(index)
```

Then let's populate an `articles` index:

```elixir
import Tirexs.Bulk
require Tirexs.ElasticSearch

settings = Tirexs.ElasticSearch.config()

Tirexs.Bulk.store [index: "articles", refresh: true], settings do
  create id: 1, title: "One", tags: ["elixir"], type: "article"
  create id: 2, title: "Two", tags: ["elixir", "ruby"], type: "article"
  create id: 3, title: "Three", tags: ["java"], type: "article"
  create id: 4, title: "Four", tags: ["erlang"], type: "article"
end
```

Now, let's go further. We will be searching for articles whose title begins with letter “T”, sorted by title in descending order, filtering them for ones tagged “elixir”, and also retrieving some facets:

```elixir
import Tirexs.Search
require Tirexs.Query

articles = search [index: "articles"] do
  query do
    string "title:T*"
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

  sort do
    [
      [title: "desc"]
    ]
  end
end

result = Tirexs.Query.create_resource(articles)

Enum.each Tirexs.Query.result(result, :hits), fn(item) ->
  IO.puts inspect(item)
  #=> [{"_index","articles"},{"_type","article"},{"_id","2"},{"_score",1.0},{"_source",[{"id",2}, {"title","Two"},{"tags",["elixir","r uby"]},{"type","article"}]}]
end
```

Let's display the global facets:
```elixir
Enum.each Tirexs.Query.result(result, :facets).global_tags.terms, fn(f) ->
  IO.puts "#{f.term}    #{f.count}"
end

#=> elixir  2
#=> ruby    1
#=> java    1
#=> erlang  1
```
Now, let's display the facets based on current query (notice that count for articles tagged with 'java' is included, even though it's not returned by our query; count for articles tagged 'erlang' is excluded, since they don't match the current query):
```elixir
Enum.each Tirexs.Query.result(result, :facets).current_tags.terms, fn(f) ->
  IO.puts "#{f.term}    #{f.count}"
end

#=> ruby    1
#=> java    1
#=> elixir  1
```
License
-------

`Tirexs` source code is released under Apache 2 License.
Check [LICENSE](https://github.com/datahogs/tirexs/blob/master/LICENSE) and [NOTICE](https://github.com/datahogs/tirexs/blob/master/NOTICE) files for more details.
