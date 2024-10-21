defmodule PDF2Image.MixProject do
  use Mix.Project

  @version "0.1.0"
  @repo_url "https://github.com/ifoo/pdf2image"

  def project do
    [
      app: :pdf2image,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Convert PDF files to images using Ghostscript",
      docs: docs(),
      package: package(),
      name: "PDF2Image"
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
      {:nimble_options, "~> 1.1"},
      {:image, "~> 0.53.0"},
      {:ex_doc, ">= 0.34.2", only: :dev}
    ]
  end

  defp package do
    [
      maintainers: ["Philip Pum"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @repo_url}
    ]
  end

  defp docs do
    [
      main: "PDF2Image",
      extras: [
        "CHANGELOG.md": [title: "Changelog"],
        "LICENSE.md": [title: "License"]
      ],
      source_ref: "v#{@version}",
      source_url: @repo_url,
      formatters: ["html"],
      skip_undefined_reference_warnings_on: ["CHANGELOG.md"]
    ]
  end
end
