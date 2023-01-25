defmodule ParkingLotWeb.CameraLive.Index do
  use ParkingLotWeb, :live_view

  alias ParkingLot.Cameras
  alias ParkingLot.Cameras.Camera

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :cameras, list_cameras())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Camera")
    |> assign(:camera, Cameras.get_camera!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Camera")
    |> assign(:camera, %Camera{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Cameras")
    |> assign(:camera, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    camera = Cameras.get_camera!(id)
    {:ok, _} = Cameras.delete_camera(camera)

    {:noreply, assign(socket, :cameras, list_cameras())}
  end

  defp list_cameras do
    Cameras.list_cameras()
  end
end
