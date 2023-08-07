defmodule ParkingLotWeb.ParkingLive.Show do
  use ParkingLotWeb, :live_view

  alias ParkingLot.Parkings

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, gettext("Show parking"))
     |> assign(:parking, Parkings.get_parking!(id))}
  end
end
