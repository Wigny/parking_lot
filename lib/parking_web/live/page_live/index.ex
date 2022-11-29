defmodule ParkingWeb.PageLive.Index do
  use ParkingWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :plate, nil)}
  end

  @impl true
  def handle_event("video_snapshot", snapshot, socket) do
    [_start, raw] = String.split(snapshot, ";base64,")
    {:ok, plate} = Parking.ALPR.recognize(raw)

    {:noreply, assign(socket, :plate, plate)}
  end
end
