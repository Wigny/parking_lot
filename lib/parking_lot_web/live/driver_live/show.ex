defmodule ParkingLotWeb.DriverLive.Show do
  use ParkingLotWeb, :live_view

  alias ParkingLot.Customers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, "Show Driver")
     |> assign(:driver, Customers.get_driver!(id))}
  end
end
