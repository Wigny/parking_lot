defmodule ParkingLot.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ParkingLotWeb.Telemetry,
      ParkingLot.Repo,
      {Phoenix.PubSub, name: ParkingLot.PubSub},
      ParkingLotWeb.Endpoint,
      {Registry, keys: :unique, name: ParkingLot.Registry},
      ParkingLot.ALPR,
      ParkingLot.ALPR.Recognizer,
      {Task,
       fn ->
         for camera <- ParkingLot.Cameras.list_cameras(active: true) do
           {:ok, _pid} = ParkingLot.ALPR.start_children(camera)
         end
       end}
    ]

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
