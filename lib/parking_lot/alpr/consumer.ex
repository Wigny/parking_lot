defmodule ParkingLot.ALPR.Consumer do
  use GenStage

  def start_link(_opts \\ []) do
    GenStage.start_link(__MODULE__, nil)
  end

  def init(nil) do
    {:consumer, nil}
  end

  def handle_events(items, _from, nil) do
    Enum.map(items, fn item ->
      IO.inspect(item)
      Phoenix.PubSub.broadcast(ParkingLot.PubSub, "recognition", {:frame, item})
    end)

    {:noreply, [], nil}
  end
end
