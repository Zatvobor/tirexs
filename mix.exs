defmodule Tirexs.Mixfile do
  use Mix.Project

  def project do
    [ app: :tirexs,
      version: "0.0.1",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    [
    {:jsonex, git: "git://github.com/devinus/jsonex.git"}
    ]
  end
end
