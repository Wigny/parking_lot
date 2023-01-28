defmodule ParkingLotWeb.HomeLive.Index do
  use ParkingLotWeb, :live_view

  alias ParkingLot.ALPR.{Image, Video}
  alias ParkingLot.Cameras

  @fps 24

  @impl true
  def mount(_params, _session, socket) do
    cameras = Cameras.list_cameras()

    {:ok,
     socket
     |> assign(:cameras, cameras)
     |> assign(:previews, [])}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    Process.send_after(self(), :preview, 100)

    {:noreply, socket}
  end

  @impl true
  def handle_info(:preview, socket) do
    previews = Enum.map(socket.assigns.cameras, &preview/1)

    Process.send_after(self(), :preview, div(:timer.seconds(1), @fps))

    {:noreply, assign(socket, :previews, previews)}
  end

  defp preview(camera) do
    %{id: camera.id, canvas: canvas(Video.frame(camera)), recognition: Image.recognition(camera)}
  end

  defp canvas(nil) do
    nil
  end

  defp canvas(frame) do
    {_dimensions, [height, width]} = Evision.Mat.size(frame)

    image =
      ".jpeg"
      |> Evision.imencode(frame)
      |> Base.encode64()
      |> then(&"data:image/jpeg;charset=utf-8;base64,#{&1}")

    %{width: width, height: height, image: image}
  end
end
