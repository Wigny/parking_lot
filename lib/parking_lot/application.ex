defmodule ParkingLot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      ParkingLot.Repo,
      # Start the Telemetry supervisor
      ParkingLotWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ParkingLot.PubSub},
      # Start the Endpoint (http/https)
      ParkingLotWeb.Endpoint,
      # Start a worker by calling: ParkingLot.Worker.start_link(arg)
      ParkingLot.ALPR.Recognizer
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ParkingLot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ParkingLotWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
