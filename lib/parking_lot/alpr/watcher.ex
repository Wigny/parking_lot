defmodule ParkingLot.ALPR.Watcher do
  @moduledoc false

  use GenServer

  alias ParkingLot.{Customers, Parkings}
  alias ParkingLot.ALPR.{Recognizer, Video}

  @license_plate_regex ~r/(?<legacy>[A-Z]{3}-?[0-9]{4})|(?<mercosul>[A-Z]{3}[0-9][A-Z][0-9]{2})/

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
    inferences = if frame, do: Recognizer.infer(frame), else: []

    send(self(), :recognize)

    GenServer.cast(self(), {:notify, %{frame: frame, inferences: inferences}})

    {:noreply, state}
  end

  @impl true
  def handle_cast({:notify, %{frame: frame, inferences: inferences}}, %{id: id} = state) do
    recognition = find_license_plate_recognition(inferences)

    preview = visualize_recognition(frame, recognition)
    vehicle = with {plate, _} <- recognition, do: Customers.get_vehicle(license_plate: plate)

    Phoenix.PubSub.broadcast(
      ParkingLot.PubSub,
      "alpr",
      {:recognition, id, %{preview: preview, vehicle: vehicle}}
    )

    GenServer.cast(self(), {:register, vehicle})

    {:noreply, state}
  end

  def handle_cast({:register, nil}, state) do
    {:noreply, state}
  end

  def handle_cast({:register, vehicle}, %{type: type} = state) do
    with {:ok, parking} <- register_parking(type, vehicle) do
      Phoenix.PubSub.broadcast(ParkingLot.PubSub, "alpr", {:parking, parking})
    end

    {:noreply, state}
  end

  defp find_license_plate_recognition(inferences) do
    inferences
    |> Enum.map(fn {text, detection} -> {capture_license_plate(text), detection} end)
    |> Enum.reject(&match?({nil, _detection}, &1))
    |> List.first()
  end

  defp capture_license_plate(text) when is_binary(text) do
    @license_plate_regex
    |> Regex.run(text)
    |> List.wrap()
    |> List.first()
  end

  defp visualize_recognition(image, nil) do
    image
  end

  defp visualize_recognition(image, {text, points}) do
    import Evision.Constant

    [b0, b1 | _] = Nx.to_flat_list(points)

    image
    |> Evision.polylines([points], true, {0, 255, 0}, thickness: 2)
    |> Evision.putText(text, {b0, b1 + 50}, cv_FONT_HERSHEY_DUPLEX(), 2, {0, 0, 255}, thickness: 5)
  end

  # the internal camera register the car exit
  defp register_parking(:internal, vehicle) do
    last_parking = Parkings.get_last_parking(vehicle_id: vehicle.id)

    if match?(%{left_at: nil}, last_parking) do
      Parkings.update_parking(last_parking, %{left_at: DateTime.utc_now()})
    else
      {:error, :already_left}
    end
  end

  # the external camera register the car entry
  defp register_parking(:external, vehicle) do
    last_parking = Parkings.get_last_parking(vehicle_id: vehicle.id)

    if match?(%{left_at: nil}, last_parking) do
      {:error, :already_entered}
    else
      Parkings.create_parking(%{vehicle_id: vehicle.id, entered_at: DateTime.utc_now()})
    end
  end
end
