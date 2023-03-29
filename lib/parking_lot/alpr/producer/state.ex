defmodule ParkingLot.ALPR.Produce.State do
  defstruct ~w[queue demand]a

  def new() do
    struct!(__MODULE__, queue: [], demand: 0)
  end

  def new(attrs) do
    struct!(__MODULE__, attrs)
  end

  def new(state, attrs) do
    struct!(state, attrs)
  end

  def inc_demand(state, demand) do
    new(state, demand: state.demand + demand)
  end

  def enqueue_item(state, item) do
    new(state, queue: Enum.concat(state.queue, [item]))
  end

  def pop_demanded(state) do
    {demanded, queue} = Enum.split(state.queue, state.demand)

    {demanded, new(queue: queue, demand: state.demand - length(queue))}
  end
end
