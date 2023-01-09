defmodule ParkingLotWeb.DriverLive.Show do
  use ParkingLotWeb, :live_view

  alias ParkingLot.Customers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:driver, Customers.get_driver!(id))}
  end

  defp page_title(:show), do: "Show Driver"
  defp page_title(:edit), do: "Edit Driver"
end
