defmodule ParkingLotWeb.HomeLive.Index do
  use ParkingLotWeb, :live_view
  import ParkingLotWeb.HomeLive.CanvasComponent

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(ParkingLot.PubSub, "alpr")
    end

    {:ok,
     socket
     |> assign(:recognitions, %{})
     |> stream(:last_parkings, [], limit: 10)}
  end

  @impl true
  def handle_info({:preview, id, preview}, socket) do
    {:noreply, update(socket, :recognitions, &Map.put(&1, id, preview))}
  end

  @impl true
  def handle_info({:parking, parking}, socket) do
    {:noreply, stream_insert(socket, :last_parkings, parking, at: 0)}
  end
end
