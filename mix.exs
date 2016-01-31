defmodule Tirexs.Mixfile do
  use Mix.Project

  def project do
    [ app: :tirexs, version: "0.7.5", elixir: "~> 1.2.1", description: description, package: package, deps: deps ]
  end

  def application do
    [applications: [:exjsx, :inets]]
  end

  defp deps do
    [ {:exjsx, "~> 3.2.0"} ]
  end

  defp description do
    """
    An Elixir flavored DSL for building JSON based queries to Elasticsearch engine
    """
  end

  defp package do
    [
      maintainers: ["Aleksey Zatvobor"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/Zatvobor/tirexs", "Contributors" => "https://github.com/Zatvobor/tirexs/graphs/contributors", "Issues" => "https://github.com/Zatvobor/tirexs/issues"}
    ]
  end
end
