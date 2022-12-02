defmodule Parking.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Parking.Repo,
      ParkingWeb.Telemetry,
      {Phoenix.PubSub, name: Parking.PubSub},
      ParkingWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Parking.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    ParkingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
