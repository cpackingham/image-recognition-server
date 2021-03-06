defmodule Glowstick.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    IO.puts("Started app!")
    children = [
      # Starts a worker by calling: Glowstick.Worker.start_link(arg)
      # {Glowstick.Worker, arg},
      Plug.Adapters.Cowboy2.child_spec(scheme: :http, plug: Glowstick.Router, options: [port: 8080])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Glowstick.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
