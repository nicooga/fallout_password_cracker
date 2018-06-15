defmodule FalloutPasswordCracker.MixProject do
  use Mix.Project

  def project, do: [
    app: :fallout_password_cracker,
    version: "0.1.0",
    elixir: "~> 1.6",
    start_permanent: Mix.env() == :prod,
    deps: deps(),
    elixirc_paths: elixirc_paths()
  ]

  def application, do: [
    mod: {FalloutPasswordCracker.Application, []},
    extra_applications: extra_applications()
  ]

  # Extra applications by env
  def extra_applications, do: extra_applications(:base) ++ extra_applications(Mix.env)
  def extra_applications(:base), do: ~w[logger]a
  def extra_applications(:dev), do: ~w[remix]a
  def extra_applications(_env), do: []

  # Extra load paths by env
  def elixirc_paths, do: elixirc_paths(:base) ++ elixirc_paths(Mix.env)
  def elixirc_paths(:base), do: ~w[lib]
  def elixirc_paths(:test), do: ~w[test/support]
  def elixirc_paths(_env), do: []

  defp deps, do: [
    {:remix, "~> 0.0.1", only: :dev} # Reloads code on console automatically
  ]
end
