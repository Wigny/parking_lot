defmodule ParkingLot.ParkingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ParkingLot.Parkings` context.
  """

  alias ParkingLot.CustomersFixtures
  alias ParkingLot.Parkings

  def valid_parking_attributes(attrs \\ %{}) do
    attrs
    |> Enum.into(%{entered_at: DateTime.utc_now(), left_at: DateTime.utc_now()})
    |> Map.put_new_lazy(:vehicle_id, fn ->
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
