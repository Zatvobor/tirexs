defmodule Tirexs.Mixfile do
  use Mix.Project

  def project do
    [ app: :tirexs, version: "0.4.0",deps: deps ]
  end

  def application, do: []

  defp deps do
    [ { :jsex, "~> 2.0.0" } ]
  end
end
