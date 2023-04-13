defmodule ParkingLotWeb.HomeLive.Index do
  use ParkingLotWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(ParkingLot.PubSub, "alpr")
    end

    {:ok, assign(socket, :recognitions, %{})}
  end

  @impl true
  def handle_info({:recognition, id, recognition}, socket) do
    %{preview: preview, vehicle: vehicle} = recognition

    {:noreply,
     update(socket, :recognitions, fn recognitions ->
       Map.put(recognitions, id, %{preview: to_canvas(preview), vehicle: vehicle})
     end)}
  end

  defp to_canvas(frame) do
    {_dimensions, [height, width]} = Evision.Mat.size(frame)
    jpeg = Evision.imencode(".jpeg", frame)
    image = "data:image/jpeg;charset=utf-8;base64,#{Base.encode64(jpeg)}"

    %{width: width, height: height, image: image}
  end
end
