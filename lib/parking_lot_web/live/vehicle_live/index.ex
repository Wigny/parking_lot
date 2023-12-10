defmodule ParkingLotWeb.VehicleLive.Index do
  use ParkingLotWeb, :live_view

  alias ParkingLot.Customers
  alias ParkingLot.Customers.Vehicle

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :vehicles, Customers.list_vehicles())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, gettext("Edit vehicle"))
    |> assign(:vehicle, Customers.get_vehicle!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, gettext("New vehicle"))
    |> assign(:vehicle, %Vehicle{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, gettext("Listing vehicles"))
    |> assign(:vehicle, nil)
  end

  @impl true
  def handle_info({ParkingLotWeb.VehicleLive.FormComponent, {:saved, vehicle}}, socket) do
    {:noreply, stream_insert(socket, :vehicles, vehicle)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    vehicle = Customers.get_vehicle!(id)

    case Customers.delete_vehicle(vehicle) do
      {:ok, _vehicle} ->
        {:noreply, stream_delete(socket, :vehicles, vehicle)}

      {:error, _changeset} ->
        message = gettext("This registry cannot be deleted!")
        {:noreply, put_flash(socket, :error, message)}
    end
  end
end
