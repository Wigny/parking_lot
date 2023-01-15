defmodule ParkingLotWeb.VehicleLive.FormComponent do
  use ParkingLotWeb, :live_component

  alias ParkingLot.{Customers, Vehicles}

  @impl true
  def update(%{vehicle: vehicle} = assigns, socket) do
    changeset = Customers.change_vehicle(vehicle)
    types = Vehicles.list_types()
    models = Vehicles.list_models()
    colors = Vehicles.list_colors()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(changeset: changeset, types: types, models: models, colors: colors)}
  end

  @impl true
  def handle_event("validate", %{"vehicle" => vehicle_params}, socket) do
    changeset =
      socket.assigns.vehicle
      |> Customers.change_vehicle(vehicle_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"vehicle" => vehicle_params}, socket) do
    save_vehicle(socket, socket.assigns.action, vehicle_params)
  end

  defp save_vehicle(socket, :edit, vehicle_params) do
    case Customers.update_vehicle(socket.assigns.vehicle, vehicle_params) do
      {:ok, _vehicle} ->
        {:noreply,
         socket
         |> put_flash(:info, "Vehicle updated successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_vehicle(socket, :new, vehicle_params) do
    case Customers.create_vehicle(vehicle_params) do
      {:ok, _vehicle} ->
        {:noreply,
         socket
         |> put_flash(:info, "Vehicle created successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
