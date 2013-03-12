import Tirexs.Search

Tirexs.DSL.define [name: "tets_index"], fn(_search, _elastic_settings) ->
  search = search do
    filter do
      nested [path: "dna"] do
        query do
          filtered do
            query do
              match_all
            end
            filter do
              nested [path: "dna.matrix"] do
                query do
                  filtered do
                    query do
                      match_all
                    end
                    filter do
                      _or do
                        filters do
                          nested [path: "dna.matrix.sport"] do
                            query do
                              range "dna.matrix.sport.choice", from: 6, to: 6
                            end
                          end
                          nested [path: "dna.matrix.sex"] do
                            query do
                              range "dna.matrix.sex.choice", from: 6, to: 6
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end    ######  ******* ********
      end     ######  ******* ********
    end      ######  ******* ********
  end       ######  ******* ********

  { search ++ _search, _elastic_settings }
end