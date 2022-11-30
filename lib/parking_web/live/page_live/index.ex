defmodule ParkingWeb.PageLive.Index do
  use ParkingWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, plate: nil, preview: "")}
  end

  @impl true
  def handle_event("video_snapshot", snapshot, socket) do
    send(self(), {:recognize, snapshot})

    {:noreply, assign(socket, :preview, snapshot)}
  end

  @impl true
  def handle_info({:recognize, snapshot}, socket) do
    [_start, raw] = String.split(snapshot, ";base64,")

    case Parking.ALPR.recognize(raw) do
      {:ok, plate} -> {:noreply, assign(socket, :plate, plate)}
      {:error, _error} -> {:noreply, socket}
    end
  end
end
