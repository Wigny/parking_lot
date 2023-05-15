defmodule ParkingLotWeb.HomeLive.Index do
  use ParkingLotWeb, :live_view
  import ParkingLotWeb.HomeLive.CanvasComponent
  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(ParkingLot.PubSub, "alpr")
    end

    {:ok, assign(socket, :recognitions, %{})}
  end

  @impl true
  def handle_info({:recognition, id, recognition}, socket) do
    {:noreply, update(socket, :recognitions, &Map.put(&1, id, recognition))}
  end

  @impl true
  def handle_info({:parking, _id, _parking}, socket) do
    {:noreply, socket}
  end
end
