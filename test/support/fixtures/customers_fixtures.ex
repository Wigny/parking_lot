defmodule ParkingLot.CustomersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ParkingLot.Customers` context.
  """

  alias ParkingLot.CheckDigit
  alias ParkingLot.Customers

  def unique_driver_cpf do
    CheckDigit.generate(:cpf)
  end

  def unique_driver_cnh do
    CheckDigit.generate(:cnh)
  end

  def unique_driver_email do
    "driver#{System.unique_integer([:positive])}@example.com"
  end

  def unique_driver_phone do
    alias CheckDigit.Digits

    11
    |> Digits.random()
    |> Digits.to_string()
  end

  def valid_driver_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      name: "some name",
      cpf: unique_driver_cpf(),
      cnh: unique_driver_cnh(),
      email: unique_driver_email(),
      phone: unique_driver_phone(),
      active: true
    })
  end

  def driver_fixture(attrs \\ %{}) do
    {:ok, driver} =
      attrs
      |> valid_driver_attributes()
      |> Customers.create_driver()

    driver
  end
end
