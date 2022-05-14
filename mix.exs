defmodule NftNews.MixProject do
  use Mix.Project

  def project do
    [
      app: :nft_news,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {NftNews.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:ocap_rpc, git: "https://github.com/dingpl716/ocap-rpc.git"}
      # {:ocap_rpc, path: "/Users/peiling/Projects/dingpl716/ocap-rpc"}
    ]
  end
end
