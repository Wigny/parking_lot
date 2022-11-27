defmodule Parking.CustomersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Parking.Customers` context.
  """

  def unique_vehicle_license_plate do
    ~r/[A-Z]{3}[0-9]{4}|[A-Z]{3}[0-9][A-Z][0-9]{2}/
    |> Randex.stream()
    |> Enum.at(0)
  end

  def valid_vehicle_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      license_plate: unique_vehicle_license_plate()
    })
  end

  def vehicle_fixture(attrs \\ %{}) do
    {:ok, vehicle} =
      attrs
      |> valid_vehicle_attributes()
      |> Parking.Customers.create_vehicle()

    vehicle
  end
end
