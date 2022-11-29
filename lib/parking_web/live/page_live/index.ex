defmodule ParkingWeb.PageLive.Index do
  use ParkingWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("video_snapshot", snapshot, socket) do
    {:noreply, socket}
  end

  defp decode(binary) do
    [_start, raw] = String.split(binary, ";base64,")
    Base.decode64!(raw)
  end
end
