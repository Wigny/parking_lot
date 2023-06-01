defmodule ParkingLot.ALPR.Watcher do
  @moduledoc false

  use GenServer

  alias ParkingLot.{Customers, Parkings}
  alias ParkingLot.ALPR.{Recognizer, Video}

  def start_link(%{id: id, type: type}, opts \\ []) do
    GenServer.start_link(__MODULE__, %{id: id, type: type}, opts)
  end

  @impl true
  def init(state) do
    Process.send_after(self(), :recognize, :timer.seconds(5))

    {:ok, state}
  end

  @impl true
  def handle_info(:recognize, %{id: id} = state) do
    [{video, nil}] = Registry.lookup(ParkingLot.Registry, "video_#{id}")

    frame = Video.frame(video)
    recognition = if frame, do: Recognizer.infer(frame)

    send(self(), :recognize)

    Phoenix.PubSub.broadcast(ParkingLot.PubSub, "alpr", {:preview, id, frame})
    GenServer.cast(self(), {:register, recognition})

    {:noreply, state}
  end

  @impl true
  def handle_cast({:register, nil}, state) do
    {:noreply, state}
  end

  @impl true
  def handle_cast({:register, recognition}, state) do
    with {:ok, vehicle} <- Customers.get_or_create_vehicle(license_plate: recognition),
         {:ok, parking} <- Parkings.register_parking(vehicle) do
      Phoenix.PubSub.broadcast(ParkingLot.PubSub, "alpr", {:parking, parking})
    end

    {:noreply, state}
  end
end
