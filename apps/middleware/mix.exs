  defmodule Middleware.MixProject do
  use Mix.Project

  def project do
    [
      app: :middleware,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Middleware.Application, []}
    ]
  end
  
  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:elastix, "~> 0.10"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.0"},
      {:hackney, "~> 1.9"},
      {:nebulex, "~> 2.1"},
      {:shards, "~> 1.0"},
      {:telemetry, "~> 0.4"},
      {:phoenix_pubsub, "~> 2.0"},
      {:libcluster, "~> 3.3"},
      {:mox, "~> 1.0", only: :test}
    ]
  end
end
