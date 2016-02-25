defmodule Tirexs.Mixfile do
  use Mix.Project

  def project do
    [ app: :tirexs, version: "0.5.0",deps: deps ]
  end

  def application, do: []

  defp deps do
    [ {:jsex, github: "talentdeficit/exjsx"} ]
  end
end
