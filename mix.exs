defmodule Nanoid.Mixfile do
  use Mix.Project

  def project do
    [
      app: :nanoid,
      name: "Nanoid",
      version: "2.1.0",
      elixir: "~> 1.12",
      source_url: "https://github.com/railsmechanic/nanoid",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      docs: docs()
    ]
  end

  def application do
    [extra_applications: [:crypto]]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.30.2", only: :dev, runtime: false},
      {:earmark, "~> 1.4.38", only: [:dev]}
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

  defp docs() do
    [
      main: "readme",
      extras: [
        "README.md"
      ],
      skip_undefined_reference_warnings_on: ["readme", "README.md"]
    ]
  end
end
