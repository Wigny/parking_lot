defmodule ParkingLotWeb.HomeLive.Index do
  use ParkingLotWeb, :live_view

  @fps 24

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(ParkingLot.PubSub, "video")
    end

    {:ok, assign(socket, :canvas, %{})}
  end

  @impl true
  def handle_info({:frame, camera_id, frame}, socket) do
    canvas = Map.put(socket.assigns.canvas, camera_id, canvas(frame))

    {:noreply, assign(socket, :canvas, canvas)}
  end

  defp canvas(nil) do
    nil
  end

  defp canvas(frame) do
    {_dimensions, [height, width]} = Evision.Mat.size(frame)
    image = to_base64(frame)

    %{width: width, height: height, image: image}
  end

  defp to_base64(frame) do
    jpeg = Evision.imencode(".jpeg", frame)
    "data:image/jpeg;charset=utf-8;base64,#{Base.encode64(jpeg)}"
  end
end
