defmodule ParkingWeb.PageLive.Index do
  use ParkingWeb, :live_view
  import Parking.ALPR, only: [recognize: 1]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, plate: nil, processing: false, vehicles: [])}
  end

  @impl true
  def handle_event("video_snapshot", _snapshot, %{assigns: %{processing: true}} = socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("video_snapshot", snapshot, socket) do
    send(self(), {:recognize, snapshot})

    {:noreply, assign(socket, :processing, true)}
  end

  @impl true
  def handle_info({:recognize, snapshot}, socket) do
    [_start, raw] = String.split(snapshot, ";base64,")

    raw
    |> recognize()
    |> register(socket)
  end

  defp register({:ok, plate}, socket) when not is_nil(plate) do
    if Enum.find(socket.assigns.vehicles, &match?(%{plate: ^plate}, &1)) do
      {:noreply, assign(socket, plate: nil, processing: false)}
    else
      vehicle = %{plate: plate, registered_at: DateTime.utc_now()}
      vehicles = Enum.concat(socket.assigns.vehicles, [vehicle])

      {:noreply, assign(socket, plate: plate, processing: false, vehicles: vehicles)}
    end
  end

  defp register(_, socket) do
    {:noreply, assign(socket, plate: nil, processing: false)}
  end
end
