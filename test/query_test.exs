Code.require_file "../test_helper.exs", __FILE__
defmodule QueryTest do
  use ExUnit.Case
  import Tirexs
  use Tirexs.Query

  test :query do
    query do
      #this is some query dsl
    end
  end

end
