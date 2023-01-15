defmodule ParkingLotWeb.VehicleDriverLive.Index do
  use ParkingLotWeb, :live_view

  alias ParkingLot.Customers
  alias ParkingLot.Customers.VehicleDriver

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :vehicles_drivers, list_vehicles_drivers())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit vehicle-driver")
    |> assign(:vehicle_driver, Customers.get_vehicle_driver!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New vehicle-driver")
    |> assign(:vehicle_driver, %VehicleDriver{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing vehicles-drivers")
    |> assign(:vehicle_driver, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    vehicle_driver = Customers.get_vehicle_driver!(id)
    {:ok, _} = Customers.delete_vehicle_driver(vehicle_driver)

    {:noreply, assign(socket, :vehicles_drivers, list_vehicles_drivers())}
  end

  defp list_vehicles_drivers do
    Customers.list_vehicles_drivers()
  end
end
