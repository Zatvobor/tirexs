defmodule Tirexs.Suggest do

  import Tirexs.DSL.Logic
  import Tirexs.Suggest.Helpers

  defmacro suggest([do: block]) do
    [suggest: extract(block)]
  end

  defmacro suggest(options, [do: block]) do
    [suggest: extract(block) ++ options]
  end

  @doc false
  def _suggest(options, suggest_opts//[]) do
    if is_list(options) do
      suggest_opts = Enum.at!(options, 0)
      options = extract_do(options, 1)
    end
    [suggest: extract(options) ++ suggest_opts]
  end

  def make_suggest(name, options, suggest_opts//[]) do
    if is_list(options) do
      suggest_opts = Enum.at!(options, 0)
      options = extract_do(options, 1)
    end
      routers(name, options, suggest_opts)
  end

  defp routers(name, options, add_options) do
    case options do
      options -> Dict.put([], to_atom(name), extract(options) ++ add_options)
    end
  end


end