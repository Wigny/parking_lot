defmodule ParkingLotWeb.VehicleLive.FormComponent do
  use ParkingLotWeb, :live_component

  alias ParkingLot.{Customers, Vehicles}

  @impl true
  def update(%{vehicle: vehicle} = assigns, socket) do
    changeset = Customers.change_vehicle(vehicle)
    models = Enum.sort_by(Vehicles.list_models(), &{&1.brand.name, &1.name})
    colors = Enum.sort_by(Vehicles.list_colors(), & &1.name)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(models: models, colors: colors)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"vehicle" => vehicle_params}, socket) do
    changeset =
      socket.assigns.vehicle
      |> Customers.change_vehicle(vehicle_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"vehicle" => vehicle_params}, socket) do
    save_vehicle(socket, socket.assigns.action, vehicle_params)
  end

  defp save_vehicle(socket, :edit, vehicle_params) do
    case Customers.update_vehicle(socket.assigns.vehicle, vehicle_params) do
      {:ok, vehicle} ->
        notify_parent({:saved, vehicle})

        {:noreply,
         socket
         |> put_flash(:info, gettext("Vehicle updated successfully"))
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_vehicle(socket, :new, vehicle_params) do
    case Customers.create_vehicle(vehicle_params) do
      {:ok, vehicle} ->
        notify_parent({:saved, vehicle})

        {:noreply,
         socket
         |> put_flash(:info, gettext("Vehicle created successfully"))
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
