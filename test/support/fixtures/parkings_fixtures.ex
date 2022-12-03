defmodule ParkingLot.ParkingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ParkingLot.Parkings` context.
  """

  @doc """
  Generate a parking.
  """
  def parking_fixture(attrs \\ %{}) do
    {:ok, parking} =
      attrs
      |> Enum.into(%{
        entered_at: ~U[2022-12-02 19:09:00Z],
        left_at: ~U[2022-12-02 19:09:00Z]
      })
      |> ParkingLot.Parkings.create_parking()

    parking
  end
end
