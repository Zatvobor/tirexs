defmodule Tirexs.Query.Bool do

  import Tirexs.Query.Helpers
  import Tirexs.Query
  import Tirexs.Helpers

  defmacro __using__(_) do
    quote do
      import unquote(Tirexs.Query.Bool)
    end
  end

  defmacro bool([do: block]) do
    quote do
      [bool: unquote(block)]
    end
  end

  defmacro must([do: block]) do
    res = Enum.map get_clear_block(block), fn(block_item) ->
      case block_item do
        {:match, _, params} -> match(params)
        {:range, _, params} -> range(params)
      end
    end
    [must: res]
  end

  defmacro should([do: block]) do
    res = Enum.map get_clear_block(block), fn(block_item) ->
      case block_item do
        {:should, _, params} -> match(params)
      end
    end
    [should: res]
  end

  defmacro must_not([do: block]) do
    quote do
      unquote(block)
    end
  end

end