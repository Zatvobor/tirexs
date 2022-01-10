defmodule Tirexs.Mixfile do
  use Mix.Project

  def project do
    [
      app: :tirexs,
      name: "Tirexs",
      version: "0.8.16",
      source_url: github(),
      homepage_url: github(),
      elixir: ">= 1.3.0",
      description: description(),
      package: package(),
      deps: deps(),
      docs: [extras: ["README.md", "CONTRIBUTING.md"]]
    ]
  end

  def application do
    [ applications: [:exjsx, :inets, :logger], env: env() ]
  end

  defp env do
    [ uri: %URI{ authority: "127.0.0.1:9200", scheme: "http", host: "127.0.0.1", port: 9200 } ]
  end

  defp deps do
    [ {:exjsx, git: "https://github.com/DataKrewTech/exjsx.git"}, {:ex_doc, "~> 0.12", only: :dev}, {:earmark, "~> 1.0", only: :dev} ]
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
      links: %{"GitHub" => github(), "Contributors" => contributors(), "Issues" => issues()}
    ]
  end

  defp github, do: "https://github.com/Zatvobor/tirexs"
  defp contributors, do: "https://github.com/Zatvobor/tirexs/graphs/contributors"
  defp issues, do: "https://github.com/Zatvobor/tirexs/issues"
end
