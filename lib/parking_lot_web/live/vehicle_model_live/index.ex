defmodule ParkingLotWeb.VehicleModelLive.Index do
  use ParkingLotWeb, :live_view

  alias ParkingLot.Vehicles
  alias ParkingLot.Vehicles.{Brand, Model}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :vehicle_models, Vehicles.list_models())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, gettext("Edit model"))
    |> assign(:model, Vehicles.get_model!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, gettext("New model"))
    |> assign(:model, %Model{brand: %Brand{}})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, gettext("Listing models"))
    |> assign(:model, nil)
  end

  @impl true
  def handle_info({ParkingLotWeb.VehicleModelLive.FormComponent, {:saved, model}}, socket) do
    {:noreply, stream_insert(socket, :vehicle_models, model)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    model = Vehicles.get_model!(id)
    {:ok, _} = Vehicles.delete_model(model)

    {:noreply, stream_delete(socket, :vehicle_models, model)}
  end
end
