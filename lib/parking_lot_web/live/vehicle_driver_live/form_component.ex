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
     |> assign(drivers: drivers, vehicles: vehicles)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"vehicle_driver" => vehicle_driver_params}, socket) do
    changeset =
      socket.assigns.vehicle_driver
      |> Customers.change_vehicle_driver(vehicle_driver_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"vehicle_driver" => vehicle_driver_params}, socket) do
    save_vehicle_driver(socket, socket.assigns.action, vehicle_driver_params)
  end

  defp save_vehicle_driver(socket, :edit, vehicle_driver_params) do
    case Customers.update_vehicle_driver(socket.assigns.vehicle_driver, vehicle_driver_params) do
      {:ok, vehicle_driver} ->
        notify_parent({:saved, vehicle_driver})

        {:noreply,
         socket
         |> put_flash(:info, gettext("Vehicle/driver updated successfully"))
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_vehicle_driver(socket, :new, vehicle_driver_params) do
    case Customers.create_vehicle_driver(vehicle_driver_params) do
      {:ok, vehicle_driver} ->
        notify_parent({:saved, vehicle_driver})

        {:noreply,
         socket
         |> put_flash(:info, gettext("Vehicle/driver created successfully"))
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
