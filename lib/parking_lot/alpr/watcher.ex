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
    [{video_server, nil}] = Registry.lookup(ParkingLot.Registry, "video_#{id}")

    frame = Video.frame(video_server)
    recognition = if frame, do: Recognizer.infer(frame)

    send(self(), :recognize)

    Phoenix.PubSub.broadcast(ParkingLot.PubSub, "alpr", {:recognition, id, recognition})

    {:noreply, state}
  end
end
