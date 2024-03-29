defmodule ParkingLotWeb.VehicleModelLive.Show do
  use ParkingLotWeb, :live_view

  alias ParkingLot.Vehicles

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:model, Vehicles.get_model!(id))}
  end

  defp page_title(:show), do: gettext("Show model")
  defp page_title(:edit), do: gettext("Edit model")
end
