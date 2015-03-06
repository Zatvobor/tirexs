defmodule Tirexs.Mixfile do
  use Mix.Project

  def project do
    [ app: :tirexs, version: "0.5.1",deps: deps ]
  end

  def application, do: []

  defp deps do
    [ {:jsex, github: "talentdeficit/jsex", tag: "v2.0.0"} ]
  end
end
