defmodule ParkingLotWeb.ParkingLive.Index do
  use ParkingLotWeb, :live_view

  alias ParkingLot.Parkings

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :parkings, Parkings.list_parkings())}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, assign(socket, :page_title, "Listing Parkings")}
  end
end
