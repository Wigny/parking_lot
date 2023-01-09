defmodule ParkingLotWeb.DriverLive.Index do
  use ParkingLotWeb, :live_view

  alias ParkingLot.Customers
  alias ParkingLot.Customers.Driver

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :drivers, list_drivers())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Driver")
    |> assign(:driver, Customers.get_driver!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Driver")
    |> assign(:driver, %Driver{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Drivers")
    |> assign(:driver, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    driver = Customers.get_driver!(id)
    {:ok, _} = Customers.delete_driver(driver)

    {:noreply, assign(socket, :drivers, list_drivers())}
  end

  defp list_drivers do
    Customers.list_drivers()
  end
end
