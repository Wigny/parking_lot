defmodule ParkingLotWeb.VehicleBrandLive.Index do
  use ParkingLotWeb, :live_view

  alias ParkingLot.Vehicles
  alias ParkingLot.Vehicles.Brand

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :vehicle_brands, Vehicles.list_brands())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Brand")
    |> assign(:brand, Vehicles.get_brand!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Brand")
    |> assign(:brand, %Brand{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Vehicle brands")
    |> assign(:brand, nil)
  end

  @impl true
  def handle_info({ParkingLotWeb.VehicleBrandLive.FormComponent, {:saved, brand}}, socket) do
    {:noreply, stream_insert(socket, :vehicle_brands, brand)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    brand = Vehicles.get_brand!(id)
    {:ok, _} = Vehicles.delete_brand(brand)

    {:noreply, stream_delete(socket, :vehicle_brands, brand)}
  end
end
