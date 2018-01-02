defmodule Nanoid.Mixfile do
  use Mix.Project

  def project do
    [
      app: :nanoid,
      version: "1.0.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
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
      {:ex_doc,   "~> 0.18.1",  only: [:dev]},
      {:earmark,  "~> 1.2.4",   only: [:dev]},
    ]
  end
end
