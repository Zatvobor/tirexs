Code.require_file "../../../test_helper.exs", __ENV__.file
defmodule Tirexs.Query.Bool.DisMax.Test do
  use ExUnit.Case
  import Tirexs.Query

  test :dis_max do
    query = query do
      dis_max do
        queries do
          term "age", 34
          term "age", 35
        end
      end
    end
    assert query == [query: [dis_max: [queries: [[term: [age: 34]],[term: [age: 35]]]]]]
  end
end
