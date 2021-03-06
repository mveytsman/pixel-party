defmodule PixelParty.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PixelPartyWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PixelParty.PubSub},
      # Start the Endpoint (http/https)
      PixelPartyWeb.Endpoint,

      PixelParty.Presence,

      # Start a worker by calling: PixelParty.Worker.start_link(arg)
       PixelParty.Grid
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PixelParty.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PixelPartyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
