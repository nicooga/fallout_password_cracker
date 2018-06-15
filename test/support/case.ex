defmodule FalloutPasswordCracker.Test.Case do
  defmacro __using__(options) do
    quote do
      use ExUnit.Case, unquote(options)

      def setup_server(server) do
        case GenServer.start_link(server, [], name: server) do
          {:ok, pid} ->
            on_exit fn -> Process.alive?(pid) && GenServer.stop(pid) end
            pid

          {:error, {:already_started, pid}} ->
            Process.alive?(pid) && GenServer.stop(pid)
            setup_server(server)
        end
      end
    end
  end
end
