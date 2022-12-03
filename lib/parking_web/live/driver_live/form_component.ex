defmodule ParkingWeb.DriverLive.FormComponent do
  use ParkingWeb, :live_component

  alias ParkingLot.Customers

  @impl true
  def update(%{driver: driver} = assigns, socket) do
    changeset = Customers.change_driver(driver)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"driver" => driver_params}, socket) do
    changeset =
      socket.assigns.driver
      |> Customers.change_driver(driver_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"driver" => driver_params}, socket) do
    save_driver(socket, socket.assigns.action, driver_params)
  end

  defp save_driver(socket, :new, driver_params) do
    case Customers.create_driver(driver_params) do
      {:ok, _driver} ->
        {:noreply,
         socket
         |> put_flash(:info, "Driver created successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
