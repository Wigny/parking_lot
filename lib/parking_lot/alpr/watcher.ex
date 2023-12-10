defmodule ParkingLot.ALPR.Watcher do
  @moduledoc false

  use GenServer

  alias ParkingLot.{Customers, Parkings}
  alias ParkingLot.Customers.Vehicle
  alias ParkingLot.ALPR.{Heuristics, Recognizer, Video}

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

    Phoenix.PubSub.broadcast(ParkingLot.PubSub, "alpr", {:frame, camera.id, frame})
    GenServer.cast(self(), {:register, recognition})

    {:noreply, state}
  end

  @impl true

  # when there is no recognition: does nothing
  def handle_cast({:register, nil}, %{recognitions: []} = state) do
    {:noreply, state}
  end

  # when the license plate was already recognized: finds the most frequently
  # predicted characters and register parking
  def handle_cast({:register, nil}, %{recognitions: recognitions, camera: camera} = state) do
    if license_plate = retrieve_license_plate(recognitions) do
      with %Vehicle{} = vehicle <- Customers.get_vehicle(license_plate: license_plate),
           {:ok, parking} <- Parkings.register_parking(camera.type, vehicle) do
        Phoenix.PubSub.broadcast(ParkingLot.PubSub, "alpr", {:parking, parking})
      end
    end

    {:noreply, %{state | recognitions: []}}
  end

  # when the license plate is being recognized: adds it into the queue
  def handle_cast({:register, recognition}, %{recognitions: recognitions} = state) do
    {:noreply, %{state | recognitions: [recognition | recognitions]}}
  end

  defp retrieve_license_plate(recognitions) do
    recognitions
    |> apply_temporal_redundancy()
    |> replace_layout_characters()
  end

  defp replace_layout_characters({"Brazilian", characters})
       when byte_size(characters) == 7 do
    Heuristics.replace_characters(:legacy, characters)
  end

  # The neural network model was not trained for mercosur plates, so we are considering here that
  # any license plate that is not Brazilian should be considered a mercosur one
  defp replace_layout_characters({_license_plate_layout, characters})
       when byte_size(characters) == 7 do
    Heuristics.replace_characters(:mercosur, characters)
  end

  defp replace_layout_characters({_license_plate_layout, _characters}) do
    nil
  end

  defp apply_temporal_redundancy(recognitions) do
    {_vehicle_types, license_plate_layouts, license_plates} = Enum.unzip(recognitions)

    layout = Heuristics.majority_voting(license_plate_layouts)
    characters = Enum.join(Enum.zip_with(license_plates, &Heuristics.majority_voting/1))

    {layout, characters}
  end
end
