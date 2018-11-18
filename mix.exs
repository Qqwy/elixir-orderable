defmodule Orderable.MixProject do
  use Mix.Project

  def project do
    [
      app: :orderable,
      version: "0.2.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      description: description(),
      source_url: "https://github.com/Qqwy/elixir-orderable",
      consolidate_protocols: Mix.env != :dev
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

      {:stream_data, "~> 0.1", only: :test},
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev},
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package() do
    [
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README* ),
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => "https://github.com/Qqwy/elixir-orderable"
      }
    ]
  end

  defp description() do
    "A protocol for making your custom datastructures orderable (for sorting and comparing.)."
  end
end
