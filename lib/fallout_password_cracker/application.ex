defmodule FalloutPasswordCracker.Application do
  def start(_type, _args) do
    import Supervisor.Spec

    children = [worker(FalloutPasswordCracker.Cracker.Server, [])]

    Supervisor.start_link(
      children,
      strategy: :one_for_one,
      name: FalloutPasswordCracker.Supervisor
    )
  end
end
