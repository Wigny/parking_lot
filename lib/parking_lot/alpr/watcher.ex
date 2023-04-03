defmodule ParkingLot.ALPR.Watcher do
  use GenServer

  alias ParkingLot.ALPR.{Recognizer, Video}

  def start_link(%{id: id}, opts \\ []) do
    GenServer.start_link(__MODULE__, %{id: id}, opts)
  end

  @impl true
  def init(state) do
    Process.send_after(self(), :recognize, :timer.seconds(5))

    {:ok, state}
  end

  @impl true
  def handle_info(:recognize, %{id: id} = state) do
    [{video, nil}] = Registry.lookup(ParkingLot.Registry, "video_#{id}")

    frame = Video.frame(video)
    recognitions = if frame, do: Recognizer.infer(frame)

    send(self(), :recognize)

    preview = if frame, do: Enum.reduce(recognitions, frame, &draw/2)

    Phoenix.PubSub.broadcast(ParkingLot.PubSub, "alpr", {:recognition, id, {nil, preview}})

    {:noreply, state}
  end

  defp draw(nil, image) do
    image
  end

  defp draw({text, points}, image) do
    import Evision.Constant, only: [cv_FONT_HERSHEY_DUPLEX: 0]

    [b0, b1 | _] = Nx.to_flat_list(points)

    box = Evision.polylines(image, [points], true, {0, 255, 0}, thickness: 2)
    Evision.putText(box, text, {b0, b1 + 12}, cv_FONT_HERSHEY_DUPLEX(), 1.0, {0, 0, 255})
  end
end
