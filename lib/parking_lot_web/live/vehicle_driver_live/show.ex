defmodule ParkingLotWeb.VehicleDriverLive.Show do
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
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:vehicle_driver, Customers.get_vehicle_driver!(id))}
  end

  defp page_title(:show), do: gettext("Show vehicle/driver")
  defp page_title(:edit), do: gettext("Edit vehicle/driver")
end
