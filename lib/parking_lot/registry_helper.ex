defmodule ParkingLot.RegistryHelper do
  @moduledoc false

  def name(key, value) do
    {:via, Registry, {ParkingLot.Registry, key, value}}
  end

  def pid(key, value) do
    ParkingLot.Registry
    |> Registry.lookup(key)
    |> Enum.map(fn {p, k} -> {k, p} end)
    |> Keyword.get(value)
  end
end
