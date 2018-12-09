defmodule Nanoid.Mixfile do
  use Mix.Project

  def project do
    [
      app: :nanoid,
      version: "2.0.1",
      elixir: "~> 1.4",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "Nanoid",
      source_url: "https://github.com/railsmechanic/nanoid"
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:ex_doc, "~> 0.19.1", only: [:dev]},
      {:earmark, "~> 1.3.0", only: [:dev]}
    ]
  end

  defp description do
    "Elixir port of NanoID (https://github.com/ai/nanoid), a tiny, secure URL-friendly unique string ID generator."
  end

  defp package do
    [
      maintainers: ["Matthias Kalb"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/railsmechanic/nanoid"}
    ]
  end
end
