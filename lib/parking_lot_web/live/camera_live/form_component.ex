defmodule ParkingLotWeb.CameraLive.FormComponent do
  use ParkingLotWeb, :live_component

  alias ParkingLot.Cameras

  @impl true
  def update(%{camera: camera} = assigns, socket) do
    changeset = Cameras.change_camera(camera)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"camera" => camera_params}, socket) do
    changeset =
      socket.assigns.camera
      |> Cameras.change_camera(camera_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"camera" => camera_params}, socket) do
    save_camera(socket, socket.assigns.action, camera_params)
  end

  defp save_camera(socket, :edit, camera_params) do
    case Cameras.update_camera(socket.assigns.camera, camera_params) do
      {:ok, _camera} ->
        {:noreply,
         socket
         |> put_flash(:info, "Camera updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_camera(socket, :new, camera_params) do
    case Cameras.create_camera(camera_params) do
      {:ok, _camera} ->
        {:noreply,
         socket
         |> put_flash(:info, "Camera created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
