defmodule ParkingLotWeb.ParkingLive.Index do
  use ParkingLotWeb, :live_view

  alias ParkingLot.Parkings

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply,
     socket
     |> assign(:page_title, "Listing Parkings")
     |> assign(:parkings, Parkings.list_parkings())}
  end
end
