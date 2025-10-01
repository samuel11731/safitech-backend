defmodule SafitechBackend.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SafitechBackendWeb.Telemetry,
      SafitechBackend.Repo,
      {DNSCluster, query: Application.get_env(:safitech_backend, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SafitechBackend.PubSub},
      # Start a worker by calling: SafitechBackend.Worker.start_link(arg)
      # {SafitechBackend.Worker, arg},
      # Start to serve requests, typically the last entry
      SafitechBackendWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SafitechBackend.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SafitechBackendWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
