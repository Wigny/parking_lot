defmodule ParkingLotWeb.VehicleDriverLive.Index do
  use ParkingLotWeb, :live_view

  alias ParkingLot.Customers
  alias ParkingLot.Customers.VehicleDriver

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :vehicles_drivers, Customers.list_vehicles_drivers())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Vehicle driver")
    |> assign(:vehicle_driver, Customers.get_vehicle_driver!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Vehicle driver")
    |> assign(:vehicle_driver, %VehicleDriver{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Vehicles drivers")
    |> assign(:vehicle_driver, nil)
  end

  @impl true
  def handle_info(
        {ParkingLotWeb.VehicleDriverLive.FormComponent, {:saved, vehicle_driver}},
        socket
      ) do
    {:noreply, stream_insert(socket, :vehicles_drivers, vehicle_driver)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    vehicle_driver = Customers.get_vehicle_driver!(id)
    {:ok, _} = Customers.delete_vehicle_driver(vehicle_driver)

    {:noreply, stream_delete(socket, :vehicles_drivers, vehicle_driver)}
  end
end
