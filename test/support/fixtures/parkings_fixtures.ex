defmodule ParkingLot.ParkingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ParkingLot.Parkings` context.
  """

  alias ParkingLot.Parkings
  alias ParkingLot.CustomersFixtures

  def valid_parking_attributes(attrs \\ %{}) do
    Map.put_new_lazy(attrs, :vehicle_id, fn ->
      vehicle = CustomersFixtures.vehicle_fixture()
      vehicle.id
    end)
  end

  def parking_fixture(attrs \\ %{}) do
    {:ok, parking} =
      attrs
      |> valid_parking_attributes()
      |> Parkings.create_parking()

    parking
  end
end
