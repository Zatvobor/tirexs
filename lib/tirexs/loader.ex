defmodule Tirexs.Loader do
  @moduledoc false

  @doc false
  def load_all(path) do
    Enum.each Path.wildcard(to_binary(path) <> "/*.exs"), fn(f) -> Code.load_file(f) end
  end

  @doc false
  def load(file) do
    to_binary(file) |> Code.load_file
  end
end
