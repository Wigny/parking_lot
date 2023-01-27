defmodule ParkingLot.ALPR do
  @moduledoc false

  use Supervisor

  alias ParkingLot.ALPR.{Image, Text, Video}
  alias ParkingLot.Cameras

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    Cameras.list_cameras()
    |> Enum.reduce([Text.Recognizer], fn camera, children ->
      [{Video, camera}, {Image, camera} | children]
    end)
    |> Supervisor.init(strategy: :one_for_one)
  end
end
