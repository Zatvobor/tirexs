defmodule Mix.Tasks.Travis do
  use Mix.Task

  def run(_) do
    Mix.Task.run("test", ["test/tirexs"])
  end
end