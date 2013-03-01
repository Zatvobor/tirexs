defmodule Mix.Tasks.Travis do
  use Mix.Task

  @shortdoc "Runs only unit tests whereas acceptances are skipped"

  def run(_) do
    Mix.Task.run("test", ["test/tirexs"])
  end
end