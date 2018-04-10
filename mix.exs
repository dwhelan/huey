defmodule Huey.MixProject do
  use Mix.Project

  def project do
    [
      app: :huey,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :httpoison, :cowboy, :plug],
      mod: {Huey, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mix_test_watch, "~> 0.5", only: :dev},
      {:exvcr, "~> 0.8", only: :test},
      {:huex, "~> 0.7"},
      {:cowboy, "~> 1.0.3"},
      {:plug, "~> 1.0"},
      {:poison, "~> 3.0"},
    ]
  end
end
