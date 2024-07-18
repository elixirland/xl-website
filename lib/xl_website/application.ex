defmodule XlWebsite.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      XlWebsiteWeb.Telemetry,
      # Start the Ecto repository
      XlWebsite.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: XlWebsite.PubSub},
      # Start Finch
      {Finch, name: XlWebsite.Finch},
      # Start the Endpoint (http/https)
      XlWebsiteWeb.Endpoint
      # Start a worker by calling: XlWebsite.Worker.start_link(arg)
      # {XlWebsite.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: XlWebsite.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    XlWebsiteWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
