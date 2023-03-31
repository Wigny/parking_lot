defmodule ParkingLotWeb.HomeLive.Index do
  use ParkingLotWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(ParkingLot.PubSub, "alpr")
    end

    {:ok, assign(socket, :previews, %{})}
  end

  @impl true
  def handle_info({:recognition, _id, nil}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info({:recognition, id, {texts, preview}}, socket) do
    IO.inspect(texts)

    {:noreply, update(socket, :previews, &Map.put(&1, id, to_canvas(preview)))}
  end

  defp to_canvas(frame) do
    {_dimensions, [height, width]} = Evision.Mat.size(frame)
    jpeg = Evision.imencode(".jpeg", frame)
    image = "data:image/jpeg;charset=utf-8;base64,#{Base.encode64(jpeg)}"

    %{width: width, height: height, image: image}
  end
end
