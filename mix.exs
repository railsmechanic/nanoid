defmodule Nanoid.Mixfile do
  use Mix.Project

  @version "3.0.0-rc.2"

  def project do
    [
      app: :nanoid,
      name: "Nanoid",
      version: @version,
      elixir: "~> 1.15",
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
      {:ex_doc, "~> 0.34", only: :dev, runtime: false}
    ]
  end

  defp description do
    "Elixir port of NanoID (https://github.com/ai/nanoid), a tiny, secure URL-friendly unique string ID generator."
  end

  defp package do
    [
      maintainers: ["Matthias Kalb"],
      licenses: ["MIT"],
      files: ~w(lib mix.exs README.md CHANGELOG.md LICENSE),
      links: %{
        "GitHub" => "https://github.com/railsmechanic/nanoid",
        "Changelog" => "https://github.com/railsmechanic/nanoid/blob/master/CHANGELOG.md"
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      source_ref: @version,
      extras: [
        "README.md",
        "CHANGELOG.md"
      ],
      skip_undefined_reference_warnings_on: ["readme", "README.md", "CHANGELOG.md"]
    ]
  end
end
