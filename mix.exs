defmodule Tirexs.Mixfile do
  use Mix.Project

  def project do
    [ app: :tirexs,
      version: "0.2",
      deps: deps ]
  end

  def application, do: []

  defp deps do
    [
      {:jsonex, github: "devinus/jsonex"}
    ]
  end
end
