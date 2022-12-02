defmodule Parking.ALPR.State do
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def last do
    Agent.get(__MODULE__, fn vehicles -> List.last(vehicles) end)
  end

  def list do
    Agent.get(__MODULE__, & &1)
  end

  def insert(vehicle) do
    Agent.update(__MODULE__, fn vehicles -> vehicles ++ [vehicle] end)
  end
end
