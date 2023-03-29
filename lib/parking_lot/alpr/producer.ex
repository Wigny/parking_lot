defmodule ParkingLot.ALPR.Producer do
  use GenStage

  alias ParkingLot.ALPR.Produce.State

  def start_link(_opts \\ []) do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    state = State.new()

    Phoenix.PubSub.subscribe(ParkingLot.PubSub, "video")

    {:producer, state}
  end

  def handle_demand(demand, %State{queue: []} = state) do
    state = State.inc_demand(state, demand)

    {:noreply, [], state}
  end

  def handle_demand(demand, state) do
    state = State.inc_demand(state, demand)
    {items, state} = State.pop_demanded(state)

    {:noreply, items, state}
  end

  def handle_info({:frame, frame}, %State{demand: 0} = state) do
    state = State.enqueue_item(state, frame)

    {:noreply, [], state}
  end

  def handle_info({:frame, frame}, state) do
    state = State.enqueue_item(state, frame)
    {items, state} = State.pop_demanded(state)

    {:noreply, items, state}
  end
end
