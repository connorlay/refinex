defmodule Refinex.MixProject do
  use Mix.Project

  def project do
    [
      app: :refinex,
      version: "0.1.0-dev",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "Refinex",
      source_url: "https://github.com/connorlay/refinex",
      docs: [
        main: "Refinex",
        extras: ["README.md"]
      ],
      dialyzer: [
        plt_core_path: "./_dialyzer",
        plt_file: {:no_warn, "./_dialyzer/refinex.plt"},
        plt_add_apps: [:mix]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 0.9.3", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.3", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.18.0", only: [:dev], runtime: false}
    ]
  end
end
