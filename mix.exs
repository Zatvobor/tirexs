defmodule Tirexs.Mixfile do
  use Mix.Project

  def project do
    [ app: :tirexs,
      version: "0.4.dev",
      deps: deps ]
  end

  def application, do: []

  defp deps do
    [
      {:jsonex, github: "devinus/jsonex", ref: "62692a62b7415625ec53b278dda8d0227a535f15"}
    ]
  end
end
