defmodule ParkingWeb.VehicleLive.Index do
  use ParkingWeb, :live_view

  alias ParkingLot.Customers
  alias ParkingLot.Customers.Vehicle

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :vehicles, list_vehicles())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Vehicle")
    |> assign(:vehicle, %Vehicle{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Vehicles")
    |> assign(:vehicle, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    vehicle = Customers.get_vehicle!(id)
    {:ok, _} = Customers.delete_vehicle(vehicle)

    {:noreply, assign(socket, :vehicles, list_vehicles())}
  end

  defp list_vehicles do
    Customers.list_vehicles()
  end
end
