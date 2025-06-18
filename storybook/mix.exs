defmodule SaladStorybook.MixProject do
  use Mix.Project

  def project do
    [
      app: :salad_storybook,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      releases: releases()
    ]
  end

  defp releases do
    [
      salad_storybook: [
        include_executables_for: [:unix],
        applications: [
          runtime_tools: :permanent,
          salad_storybook: :permanent
        ],
        strip_beams: [
          keep: ["Docs"]
        ]
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {SaladStorybook.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:dns_cluster, "~> 0.2"},
      {:ecto_sql, "~> 3.13"},
      {:esbuild, "~> 0.10", runtime: Mix.env() == :dev},
      {:faker, "~> 0.18"},
      {:finch, "~> 0.13"},
      {:floki, "~> 0.38"},
      {:gettext, "~> 0.26"},
      {:jason, "~> 1.4"},
      {:lucide_icons, "~> 2.0"},
      {:phoenix_ecto, "~> 4.6"},
      {:phoenix_html, "~> 4.2"},
      {:phoenix_live_dashboard, "~> 0.8"},
      {:phoenix_live_reload, "~> 1.6", only: :dev},
      {:phoenix_live_view, "~> 1.0"},
      {:phoenix_storybook, "~> 0.8"},
      {:phoenix, "~> 1.7"},
      {:plug_cowboy, "~> 2.7"},
      {:postgrex, ">= 0.0.0"},
      {:styler, "~> 1.4", only: [:dev, :test], runtime: false},
      {:swoosh, "~> 1.19"},
      {:tailwind, "~> 0.3", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "~> 1.1"},
      {:telemetry_poller, "~> 1.2"},

      # load local salad_ui on dev from local path
      (Mix.env() == :prod &&
         {:salad_ui, github: "bluzky/salad_ui", tag: "v1.0.0-alpha.2"}) ||
        {:salad_ui, path: "../"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind default", "esbuild default"],
      "assets.deploy": [
        "tailwind default --minify",
        "tailwind storybook --minify",
        "esbuild default --minify",
        "phx.digest"
      ]
    ]
  end
end
