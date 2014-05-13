defmodule Tirexs.Mixfile do
  use Mix.Project

  def project do
    [ app: :tirexs, version: "0.4.1-dev",deps: deps ]
  end

  def application, do: []

  defp deps do
    [ {:jsex, github: "talentdeficit/jsex"} ]
  end
end