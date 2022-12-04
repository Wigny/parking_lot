defmodule ParkingLotWeb.PageLive.Index do
  use ParkingLotWeb, :live_view

  import ParkingLot.ALPR, only: [recognize: 1]
  alias ParkingLot.{Customers, Parkings}

  @impl true
  def mount(_params, _session, socket) do
    assigns = [plate: nil, processing: false, parkings: Parkings.list_parkings()]
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_event("video_snapshot", snapshot, %{assigns: %{processing: false}} = socket) do
    send(self(), {:recognize, snapshot})

    assigns = [processing: true]
    {:noreply, assign(socket, assigns)}
  end

  @impl true
  def handle_event("video_snapshot", _snapshot, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info({:recognize, snapshot}, socket) do
    [_start, raw] = String.split(snapshot, ";base64,")

    raw
    |> recognize()
    |> register(socket)
  end

  defp register({:ok, plate}, socket) when not is_nil(plate) do
    vehicle = Customers.get_vehicle(license_plate: plate)
    already_parked? = vehicle && Parkings.get_parking(vehicle_id: vehicle.id)

    if already_parked? do
      assigns = [plate: plate, processing: false]
      {:noreply, assign(socket, assigns)}
    else
      {:ok, _parking} = Parkings.register_parking(%{vehicle_id: vehicle.id})

      assigns = [plate: plate, processing: false, parkings: Parkings.list_parkings()]
      {:noreply, assign(socket, assigns)}
    end
  end

  defp register(_, socket) do
    {:noreply, assign(socket, plate: nil, processing: false)}
  end
end
