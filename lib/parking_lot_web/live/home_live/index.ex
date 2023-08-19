defmodule ParkingLotWeb.HomeLive.Index do
  use ParkingLotWeb, :live_view

  import ParkingLotWeb.HomeLive.CanvasComponent
  alias ParkingLot.{Cameras, Parkings}
  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(ParkingLot.PubSub, "alpr")
    end

    cameras = Cameras.list_cameras()
    parkings = Parkings.list_parkings([], order: [desc: :id], limit: 10)

    {:ok,
     socket
     |> assign(:cameras, cameras)
     |> assign(:videos, %{})
     |> stream(:last_parkings, parkings, limit: 10)}
  end

  @impl true
  def handle_info({:frame, camera_id, frame}, socket) do
    {:noreply, update(socket, :videos, &Map.put(&1, camera_id, frame))}
  end

  @impl true
  def handle_info({:parking, parking}, socket) do
    {:noreply, stream_insert(socket, :last_parkings, parking, at: 0)}
  end
end
