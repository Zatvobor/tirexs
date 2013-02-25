Code.require_file "../../test_helper.exs", __FILE__
defmodule Query.Bool.Test do
  use ExUnit.Case
  import Tirexs
  use Tirexs.Query


  test :bool do
    query = [query: [], filters: []]
    query do
      bool do
        must do
          match "artist_uri",  "medianet:artist:261633", operator: "and"
        end
      end
    end
  end

end