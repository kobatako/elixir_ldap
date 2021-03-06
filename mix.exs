defmodule ElixirLdap.Mixfile do
  use Mix.Project

  def project do
    [
      app: :elixir_ldap,
      version: "0.4.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      description: "elixir LDAP Client",
      package: [
        maintainers: ["kobatako"],
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/kobatako/elixir_ldap"}
      ],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :eldap]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0"}
    ]
  end

  defp aliases do
    [
      release: ["mix hex.publish", "mix hex.docs"]
    ]
  end
end
