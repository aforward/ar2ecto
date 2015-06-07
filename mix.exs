defmodule Ar2ecto.Mixfile do
  use Mix.Project

  @version "0.1.2"

  def project do
    [app: :ar2ecto,
     version: @version,
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,

     # Hex
     description: description,
     package: package,

     # Docs
     name: "Ar2ecto",
     docs: [source_ref: "v#{@version}",
            source_url: "https://github.com/aforward/ar2ecto"]]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    []
  end

  defp description do
    """
    Ar2ecto is a set of mix tasks to help you migrate from ActiveRecord to Ecto.
    """
  end

  defp package do
    [contributors: ["Andrew Forward"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/aforward/ar2ecto"},
     files: ~w(mix.exs README.md lib)]
  end

end
