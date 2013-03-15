defmodule Tirexs.Rescore do
  import Tirexs.DSL.Logic
  import Tirexs.Rescore.Helpers

  defmacro rescore([do: block]) do
    [rescore: extract(block)]
  end

  defmacro rescore(options, [do: block]) do
    [rescore: extract(block) ++ options]
  end

  def _rescore(options, rescore_opts//[]) do
    if is_list(options) do
      rescore_opts = Enum.at!(options, 0)
      options = extract_do(options, 1)
    end
    [rescore: extract(options) ++ rescore_opts]
  end
end