defmodule FalloutPasswordCracker.MixProject do
  use Mix.Project

  def project, do: [
    app: :fallout_password_cracker,
    version: "0.1.0",
    elixir: "~> 1.6",
    start_permanent: Mix.env() == :prod,
    deps: deps(),
    elixirc_paths: elixirc_paths(),
    escript: escript()
  ]

  def application, do: [
    mod: {FalloutPasswordCracker.Application, []},
    extra_applications: extra_applications()
  ]

  # Extra applications by env
  defp extra_applications, do: extra_applications(:base) ++ extra_applications(Mix.env)
  defp extra_applications(:base), do: ~w[logger]a
  defp extra_applications(:dev), do: ~w[remix]a
  defp extra_applications(_env), do: []

  # Extra load paths by env
  defp elixirc_paths, do: elixirc_paths(:base) ++ elixirc_paths(Mix.env)
  defp elixirc_paths(:base), do: ~w[lib]
  defp elixirc_paths(:test), do: ~w[test/support]
  defp elixirc_paths(_env), do: []

  defp deps, do: [
    {:remix, "~> 0.0.1", only: :dev} # Reloads code on console automatically
  ]

  defp escript, do: [
    main_module: FalloutPasswordCracker.CLI,
    path: "bin/fallout_password_cracker"
  ]
end
