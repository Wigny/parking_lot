defmodule ParkingLot.Algorithm do
  def majority_voting(enumerable) do
    Enum.zip_with(enumerable, fn elem -> average(elem, :mode) end)
  end

  def average(enumerable, :mode) do
    enumerable
    |> Enum.frequencies()
    |> Enum.max_by(fn {_elem, frequency} -> frequency end)
    |> then(fn {elem, _frequency} -> elem end)
  end
end
