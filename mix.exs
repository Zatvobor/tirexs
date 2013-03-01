defmodule Tirexs.Mixfile do
  use Mix.Project

  def project do
    [ app: :tirexs,
      version: "0.2.dev",
      deps: deps ]
  end

  def application, do: []

  defp deps do
    [
      {:jsonex, git: "git://github.com/devinus/jsonex.git"}
    ]
  end
end
