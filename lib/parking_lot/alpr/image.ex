defmodule ParkingLot.ALPR.Image do
  @moduledoc false

  use GenServer

  alias ParkingLot.ALPR.{Text, Video}
  alias ParkingLot.Cameras

  def start_link(%Cameras.Camera{id: id} = camera) do
    name = {:via, Registry, {ParkingLot.Registry, "image_#{id}"}}
    GenServer.start_link(__MODULE__, %{camera: camera}, name: name)
  end

  @impl true
  def init(state) do
    Process.send_after(self(), :recognize, :timer.seconds(5))

    {:ok, state}
  end

  @impl true
  def handle_info(:recognize, state) do
    _license_plate = recognize(state.camera)

    Process.send_after(self(), :recognize, 100)

    {:noreply, state}
  end

  defp recognize(camera) do
    if frame = Video.frame(camera) do
      Text.Recognizer.infer(frame)
    end
  end
end
