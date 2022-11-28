defmodule ParkingWeb.DriverLive.Show do
  use ParkingWeb, :live_view

  alias Parking.Customers

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
