tirexs
====

A DSL for the ElasticSearch search engine. Inspired by https://github.com/karmi/tire

    index = create_index("test") #important index varible are using in dsl!
    settings "settings" do
      mappings do
        indexes "mn_opts_", [type: "nested"] do
          indexes "uk", [type: "nested"] do
            indexes "credentials", [type: "nested"] do
              indexes "available_from", type: "long"
              indexes "buy", type: "nested"
              indexes "dld", type: "nested"
              indexes "str", type: "nested"
              indexes "t2p", type: "nested"
              indexes "sby", type: "nested"
              indexes "spl", type: "nested"
              indexes "spd", type: "nested"
              indexes "pre", type: "nested"
              indexes "fst", type: "nested"
            end
          end
          indexes "ca", [type: "nested"] do
            indexes "credentials", [type: "nested"] do
              indexes "available_from", type: "long"
              indexes "buy", type: "nested"
              indexes "dld", type: "nested"
              indexes "str", type: "nested"
              indexes "t2p", type: "nested"
              indexes "sby", type: "nested"
              indexes "spl", type: "nested"
              indexes "spd", type: "nested"
              indexes "pre", type: "nested"
              indexes "fst", type: "nested"
            end
          end
          indexes "us", [type: "nested"] do
            indexes "credentials", [type: "nested"] do
              indexes "available_from", type: "long"
              indexes "buy", type: "nested"
              indexes "dld", type: "nested"
              indexes "str", type: "nested"
              indexes "t2p", type: "nested"
              indexes "sby", type: "nested"
              indexes "spl", type: "nested"
              indexes "spd", type: "nested"
              indexes "pre", type: "nested"
              indexes "fst", type: "nested"
            end
          end
        end
        indexes "rev_history_", type: "nested"
      end
    end

