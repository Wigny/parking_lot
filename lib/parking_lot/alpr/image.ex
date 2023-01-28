defmodule ParkingLot.ALPR.Image do
  @moduledoc false

  use GenServer

  alias ParkingLot.ALPR.{Text, Video}
  alias ParkingLot.Cameras.Camera

  def start_link(%Camera{id: id} = camera) do
    name = {:via, Registry, {ParkingLot.Registry, "image_#{id}"}}
    GenServer.start_link(__MODULE__, %{camera: camera}, name: name)
  end

  def recognition(%Camera{id: id}) do
    [{pid, nil}] = Registry.lookup(ParkingLot.Registry, "image_#{id}")
    GenServer.call(pid, :recognition)
  end

  @impl true
  def init(state) do
    Process.send_after(self(), :recognize, :timer.seconds(5))

    {:ok, state}
  end

  @impl true
  def handle_call(:recognition, _from, state) do
    {:reply, state[:recognition], state}
  end

  @impl true
  def handle_info(:recognize, state) do
    recognition = recognize(state.camera)

    Process.send_after(self(), :recognize, 100)

    {:noreply, Map.put(state, :recognition, recognition)}
  end

  defp recognize(camera) do
    if frame = Video.frame(camera) do
      frame
      |> Text.Recognizer.infer()
      |> Text.Extractor.capture()
    end
  end
end
