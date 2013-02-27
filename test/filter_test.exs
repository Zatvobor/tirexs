Code.require_file "../test_helper.exs", __FILE__
defmodule FilterTest do
  use ExUnit.Case
  import Tirexs
  use Tirexs.Filter
  use Tirexs.ElasticSettings

  test :filter do
    query = filter do
      term "tag", "green"
    end

    assert query == [filter: [term: [tag: "green"]]]
  end

  test :exists do
    query = filter do
      exists "id"
    end

    IO.puts inspect(query)
  end

end