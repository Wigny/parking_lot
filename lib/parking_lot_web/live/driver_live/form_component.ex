defmodule ParkingLotWeb.DriverLive.FormComponent do
  use ParkingLotWeb, :live_component

  alias ParkingLot.Customers

  @impl true
  def update(%{driver: driver} = assigns, socket) do
    changeset = Customers.change_driver(driver)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"driver" => driver_params}, socket) do
    changeset =
      socket.assigns.driver
      |> Customers.change_driver(driver_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"driver" => driver_params}, socket) do
    save_driver(socket, socket.assigns.action, driver_params)
  end

  defp save_driver(socket, :edit, driver_params) do
    case Customers.update_driver(socket.assigns.driver, driver_params) do
      {:ok, driver} ->
        notify_parent({:saved, driver})

        {:noreply,
         socket
         |> put_flash(:info, "Driver updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_driver(socket, :new, driver_params) do
    case Customers.create_driver(driver_params) do
      {:ok, driver} ->
        notify_parent({:saved, driver})

        {:noreply,
         socket
         |> put_flash(:info, "Driver created successfully")
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
