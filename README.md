[![Build Status](https://travis-ci.org/Zatvobor/tirexs.svg?branch=master)](https://travis-ci.org/Zatvobor/tirexs) [![HEX version](https://img.shields.io/hexpm/v/tirexs.svg)](https://hex.pm/packages/tirexs) [![HEX downloads](https://img.shields.io/hexpm/dw/tirexs.svg)](https://hex.pm/packages/tirexs)

tirexs
======

An Elixir flavored DSL for building JSON based settings, mappings, queries, percolators to Elasticsearch engine.

_Hint: Check out [/examples](/examples) directory as a quick intro._


Configuration
-------------------

In your mix app, add this to your mix.exs:
```elixir
def deps do
  [{:tirexs, "~> 0.7.6"}]
end
```
To setup the elasticsearch url config, add this to dev.exs (or test/prod.exs/etc):
```elixir
# As a keyword list
config :tirexs, :uri,
  authority: "localhost:9200",
  fragment: nil,
  host: "localhost",
  path: "/",
  port: 9200,
  query: nil,
  scheme: "http",
  userinfo: nil
# Or as a URI struct
config :tirexs, :uri, %URI{authority: "localhost:9200", fragment: nil,
                           host: "localhost", path: "/", port: 9200,
                           query: nil, scheme: "http", userinfo: nil}
# Or as a full url string
config :tirexs, :uri URI.parse("http://localhost:9200")
```
NOTE: it defaults to 127.0.0.1:9200 but it is recommended to set your config settings now. Good practice.

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

# Returns the value from `Application.get_env(:tirexs, :uri)`.
settings = Tirexs.ElasticSearch.config()

Tirexs.Bulk.store [index: "articles", refresh: true], settings do
  create id: 1, title: "One", tags: ["elixir"], type: "article"
  create id: 2, title: "Two", tags: ["elixir", "ruby"], type: "article"
  create id: 3, title: "Three", tags: ["java"], type: "article"
  create id: 4, title: "Four", tags: ["erlang"], type: "article"
end
```

**NOTE**

If you want to provide a dynamic list of documents you can prepare a list of
document in this way:

```elixir
docs = [
    create: [id: 1, title: "One", tags: ["elixir"], type: "article"],
    create: [id: 2, title: "Two", tags: ["elixir", "ruby"], type: "article"],
    create: [id: 3, title: "Three", tags: ["java"], type: "article"],
    create: [id: 4, title: "Four", tags: ["erlang"], type: "article"]
    # more...
]
```

and call:

```elixir
Tirexs.Bulk.store [index: "articles", refresh: true], settings, do: docs
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
  #=> [{"_index","articles"},{"_type","article"},{"_id","2"},{"_score",1.0},{"_source",[{"id",2}, {"title","Two"},{"tags",["elixir","ruby"]},{"type","article"}]}]
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

In the end, a snippet about using a Percolator (check out the [examples/percolator.exs](examples/percolator.exs))
```elixir
percolator = percolator [index: "my-index", name: 1] do
  query do
    match "message",  "bonsai tree"
  end
end

{_, _, body} = Tirexs.Percolator.create_resource(percolator, settings)

percolator = percolator [index: "my-index", type: "message"] do
  doc do
    [[message: "A new bonsai tree in the office"]]
  end
end

{_, _, body} = Tirexs.Percolator.match(percolator, settings)
```

Not sure?
---------

Look around using [https://hex.pm/packages?search=elasticsearch...](https://hex.pm/packages?search=elasticsearch&sort=downloads) to find out some other packages.

Contributing
------------

If you feel like porting or fixing something, please drop a [pull request](https://github.com/Zatvobor/tirexs/pulls) or [issue tracker](https://github.com/Zatvobor/tirexs/issues) at GitHub! Check out the [CONTRIBUTING.md](CONTRIBUTING.md) for more details.

License
-------

`Tirexs` source code is released under Apache 2 License.
Check [LICENSE](LICENSE) and [NOTICE](NOTICE) files for more details. The project HEAD is https://github.com/zatvobor/tirexs.

[![Analytics](https://ga-beacon.appspot.com/UA-61065309-1/Zatvobor/tirexs/README)](https://github.com/igrigorik/ga-beacon)
