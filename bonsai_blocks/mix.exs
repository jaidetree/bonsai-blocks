defmodule BonsaiBlocks.MixProject do
  use Mix.Project

  def project do
    [
      app: :bonsai_blocks,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:jason, "~> 1.4"},
      {:req, "~> 0.4.0"},
      {:ex_doc, "~> 0.30.0", only: :dev, runtime: false},
      {:peri, "~> 0.3"}
    ]
  end
end
