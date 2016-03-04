defmodule Tirexs.Mixfile do
  use Mix.Project

  def project do
    [ app: :tirexs, version: "0.7.7", elixir: "~> 1.2.0", description: description, package: package, deps: deps ]
  end

  def application do
    [ applications: [:exjsx, :inets], env: env ]
  end

  defp env do
    [ uri: %URI{ scheme: "http", userinfo: nil, host: "127.0.0.1", port: 9200 } ]
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
