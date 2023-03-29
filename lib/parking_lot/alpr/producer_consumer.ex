defmodule ParkingLot.ALPR.ProducerConsumer do
  use GenStage

  alias ParkingLot.ALPR.Recognizer

  def start_link(_opts \\ []) do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    {:producer_consumer, :ok}
  end

  def handle_events(frames, _from, state) do
    events = Enum.map(frames, &Recognizer.infer/1)

    {:noreply, events, state}
  end
end
