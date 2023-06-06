defmodule ParkingLot.ALPR.Watcher do
  @moduledoc false

  use GenServer

  alias ParkingLot.{Customers, Parkings}
  alias ParkingLot.ALPR.{Recognizer, Video}

  def start_link(%{camera: camera}, opts \\ []) do
    GenServer.start_link(__MODULE__, %{camera: camera}, opts)
  end

  @impl true
  def init(%{camera: camera}) do
    Process.send_after(self(), :recognize, :timer.seconds(5))

    {:ok, %{camera: camera, recognitions: []}}
  end

  @impl true
  def handle_info(:recognize, %{camera: camera} = state) do
    [{video, nil}] = Registry.lookup(ParkingLot.Registry, "video_#{camera.id}")

    frame = Video.frame(video)
    recognition = if frame, do: Recognizer.infer(frame)

    send(self(), :recognize)

    Phoenix.PubSub.broadcast(ParkingLot.PubSub, "alpr", {:preview, camera.id, frame})
    GenServer.cast(self(), {:register, recognition})

    {:noreply, state}
  end

  @impl true

  # when there is no recognition: does nothing
  def handle_cast({:register, nil}, %{recognitions: []} = state) do
    {:noreply, state}
  end

  # when the license plate was already recognized: finds the most frequently
  # predicted characters (temporal redundancy) and register parking
  def handle_cast({:register, nil}, %{recognitions: recognitions, camera: camera} = state) do
    recognition = majority_voting(recognitions)
    parking_action = Keyword.get([internal: :leave, external: :entry], camera.type)

    with {:ok, vehicle} <- Customers.get_or_create_vehicle(license_plate: Enum.join(recognition)),
         {:ok, parking} <- Parkings.register_parking(parking_action, vehicle) do
      Phoenix.PubSub.broadcast(ParkingLot.PubSub, "alpr", {:parking, parking})
    end

    {:noreply, %{state | recognitions: []}}
  end

  # when the license plate is being recognized: adds it into the queue
  def handle_cast({:register, recognition}, %{recognitions: recognitions} = state) do
    {:noreply, %{state | recognitions: [recognition | recognitions]}}
  end

  defp majority_voting(enumerable) do
    Enum.zip_with(enumerable, fn characters ->
      characters
      |> Enum.frequencies()
      |> Enum.max_by(fn {_character, frequency} -> frequency end)
      |> then(fn {character, _frequency} -> character end)
    end)
  end
end
