defmodule ParkingLot.CustomersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ParkingLot.Customers` context.
  """

  alias ParkingLot.Customers
  alias ParkingLot.Changeset.CheckDigit

  def unique_driver_cnh do
    base = Integer.digits(99_999_999 + :rand.uniform(900_000_000))
    Enum.join(base ++ CheckDigit.predict(base, :cnh), "")
  end

  def unique_driver_cpf do
    base = Integer.digits(99_999_999 + :rand.uniform(900_000_000))
    Enum.join(base ++ CheckDigit.predict(base, :cpf), "")
  end

  def valid_driver_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      cnh: unique_driver_cnh(),
      cpf: unique_driver_cpf(),
      name: "some name"
    })
  end

  def driver_fixture(attrs \\ %{}) do
    {:ok, driver} =
      attrs
      |> valid_driver_attributes()
      |> Customers.create_driver()

    driver
  end

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
      |> Customers.create_vehicle()

    vehicle
  end
end
