[![Build Status](https://travis-ci.org/Zatvobor/tirexs.svg?branch=master)](https://travis-ci.org/Zatvobor/tirexs) [![HEX version](https://img.shields.io/hexpm/v/tirexs.svg)](https://hex.pm/packages/tirexs) [![HEX downloads](https://img.shields.io/hexpm/dw/tirexs.svg)](https://hex.pm/packages/tirexs) [![Deps Status](https://beta.hexfaktor.org/badge/all/github/Zatvobor/tirexs.svg)](https://beta.hexfaktor.org/github/Zatvobor/tirexs)

An Elixir flavored HTTP client and DSL library for building JSON based settings, mappings, queries and percolators to Elasticsearch engine.

## Getting Started

1. Add this to the `defp deps do` list in your mix.exs file:

  ```elixir
  {:tirexs, "~> 0.8"}
  ```

2. Also in mix.exs, add `:tirexs` to the `:applications` list in `def application`.
3. In config/dev.exs, configure `tirexs`:

   ```elixir
   # The default uri is http://127.0.0.1:9200
   config :tirexs, :uri, "http://127.0.0.1:9200"
   ```

   See [lib/tirexs/env.ex](https://github.com/Zatvobor/tirexs/blob/master/lib/tirexs/env.ex) for more configuration options.
4. Index a document:

  ```elixir
  import Tirexs.HTTP

  put("/my_index/users/1", [name: "Jane", email: "jane@example.com"])
  # {:ok, 201,
  #  %{_id: "1", _index: "my_index", _type: "users", _version: 1, created: true}}
  ```
5. Fetch the document:

  ```elixir
  get("/my_index/users/1")
  #  {:ok, 200,
  #   %{_id: "1", _index: "my_index",
  #     _source: %{email: "jane@example.com", name: "Jane"}, _type: "users",
  #     _version: 1, found: true}}
  ```
6. Simplified search:

  ```elixir
  get("/my_index/users/_search?q=name:jane")
  #  {:ok, 200,
  #   %{_shards: %{failed: 0, successful: 5, total: 5},
  #     hits: %{hits: [%{_id: "1", _index: "my_index", _score: 0.30685282,
  #          _source: %{email: "jane@example.com", name: "Jane"}, _type: "users"}],
  #       max_score: 0.30685282, total: 1}, timed_out: false, took: 10}}
  ```
7. Query DSL

  ```elixir
  import Tirexs.Search

  query = search [index: "my_index"] do
    query do
      match "name", "jane"
    end
  end
  # [search: [query: [match: [name: [query: "jane"]]]], index: "my_index"]

  Tirexs.Query.create_resource(query)
  #  {:ok, 200,
  #   %{_shards: %{failed: 0, successful: 5, total: 5},
  #     hits: %{hits: [%{_id: "1", _index: "my_index", _score: 0.30685282,
  #          _source: %{email: "jane@example.com", name: "Jane"}, _type: "users"}],
  #       max_score: 0.30685282, total: 1}, timed_out: false, took: 5}}
  ```

8. AWS Support
In config/dev.exs, add the following to `:tirexs`:

   ```elixir
   config :tirexs,
     uri: "https://example-amazon-url",
     http_adapter: Tirexs.HTTP.AWS,
     aws: [
       access_key_id: "AFAIKTIVSMSSEXAMPLE",
       secret_access_key: "secret-access-key",
       region: "us-east-2",
     ]
   ```

Check out [/examples](/examples) directory as a quick intro.

[![Gitter](https://badges.gitter.im/Zatvobor/tirexs.svg)](https://gitter.im/Zatvobor/tirexs?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

## tirexs is split into several layers

- [Raw HTTP layer](https://hexdocs.pm/tirexs/Tirexs.HTTP.html) and [API helpers](https://hexdocs.pm/tirexs/Tirexs.Resources.APIs.html)
- Multiple operations in single call such as [Bulk API](https://hexdocs.pm/tirexs/Tirexs.Bulk.html) and [mget API](https://hexdocs.pm/tirexs/Tirexs.MultiGet.html)
- [DSL flavored helpers](https://hexdocs.pm/tirexs/Tirexs.DSL.html)

Find out more in [api reference](https://hexdocs.pm/tirexs/api-reference.html)

## Not sure?
Look around using [https://hex.pm/packages?search=elasticsearch...](https://hex.pm/packages?search=elasticsearch&sort=downloads) to find out some other packages.

## Contributing
If you feel like porting or fixing something, please drop a [pull request](https://github.com/Zatvobor/tirexs/pulls) or [issue tracker](https://github.com/Zatvobor/tirexs/issues) at GitHub! Check out the [CONTRIBUTING.md](CONTRIBUTING.md) for more details.

## License
`Tirexs` source code is released under Apache 2 License.
Check [LICENSE](LICENSE) and [NOTICE](NOTICE) files for more details. The project HEAD is https://github.com/zatvobor/tirexs.

[![Analytics](https://ga-beacon.appspot.com/UA-61065309-1/Zatvobor/tirexs/README)](https://github.com/igrigorik/ga-beacon)
