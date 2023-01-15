defmodule ParkingLotWeb.VehicleDriverLive.FormComponent do
  use ParkingLotWeb, :live_component

  alias ParkingLot.Customers

  @impl true
  def update(%{vehicle_driver: vehicle_driver} = assigns, socket) do
    changeset = Customers.change_vehicle_driver(vehicle_driver)
    drivers = Customers.list_drivers()
    vehicles = Customers.list_vehicles()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(changeset: changeset, drivers: drivers, vehicles: vehicles)}
  end

  @impl true
  def handle_event("validate", %{"vehicle_driver" => vehicle_driver_params}, socket) do
    changeset =
      socket.assigns.vehicle_driver
      |> Customers.change_vehicle_driver(vehicle_driver_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"vehicle_driver" => vehicle_driver_params}, socket) do
    save_vehicle_driver(socket, socket.assigns.action, vehicle_driver_params)
  end

  defp save_vehicle_driver(socket, :edit, vehicle_driver_params) do
    case Customers.update_vehicle_driver(socket.assigns.vehicle_driver, vehicle_driver_params) do
      {:ok, _vehicle_driver} ->
        {:noreply,
         socket
         |> put_flash(:info, "Vehicle driver updated successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_vehicle_driver(socket, :new, vehicle_driver_params) do
    case Customers.create_vehicle_driver(vehicle_driver_params) do
      {:ok, _vehicle_driver} ->
        {:noreply,
         socket
         |> put_flash(:info, "Vehicle driver created successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
