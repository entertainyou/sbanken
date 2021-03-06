defmodule Sbanken.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      SbankenWeb.Endpoint,
      # Starts a worker by calling: Sbanken.Worker.start_link(arg)
      # {Sbanken.Worker, arg},

      {SbankenMonitor.TokenedClient, []},
      {SbankenMonitor.Notifier, []},
      {SbankenMonitor.Monitor, []},
      {SbankenMonitor.Balance, []},
      {SbankenMonitor.HealthChecks, []}
    ]

    {:ok, _} = Logger.add_backend(Sentry.LoggerBackend)
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sbanken.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SbankenWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
