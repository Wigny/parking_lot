defmodule ParkingLotWeb.CameraLive.FormComponent do
  use ParkingLotWeb, :live_component

  alias ParkingLot.Cameras

  @impl true
  def update(%{camera: camera} = assigns, socket) do
    changeset = Cameras.change_camera(camera)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"camera" => camera_params}, socket) do
    changeset =
      socket.assigns.camera
      |> Cameras.change_camera(camera_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"camera" => camera_params}, socket) do
    save_camera(socket, socket.assigns.action, camera_params)
  end

  defp save_camera(socket, :edit, camera_params) do
    case Cameras.update_camera(socket.assigns.camera, camera_params) do
      {:ok, camera} ->
        notify_parent({:saved, camera})

        {:noreply,
         socket
         |> put_flash(:info, gettext("Camera updated successfully"))
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_camera(socket, :new, camera_params) do
    case Cameras.create_camera(camera_params) do
      {:ok, camera} ->
        notify_parent({:saved, camera})

        {:noreply,
         socket
         |> put_flash(:info, gettext("Camera created successfully"))
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
