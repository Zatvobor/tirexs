defmodule Tirexs.Mixfile do
  use Mix.Project

  def project do
    [ app: :tirexs, version: "0.5.0",deps: deps ]
  end

  def application, do: []

  defp deps do
    [ {:exjsx, github: "talentdeficit/exjsx", tag: "v3.1.0"} ]
  end
end
