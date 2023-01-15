defmodule ParkingLot.CustomersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ParkingLot.Customers` context.
  """

  alias ParkingLot.CheckDigit
  alias ParkingLot.CheckDigit.Digits
  alias ParkingLot.Customers
  alias ParkingLot.VehiclesFixtures

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
    0..9
    |> Digits.random(11)
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

  def unique_vehicle_license_plate do
    letters = Enum.map(?A..?Z, &<<&1::utf8>>)
    numbers = Enum.map(?0..?9, &<<&1::utf8>>)

    Enum.join([
      Digits.random(letters, 3),
      Digits.random(numbers, 1),
      Digits.random(letters, 1),
      Digits.random(numbers, 2)
    ])
  end

  def valid_vehicle_attributes(attrs \\ %{}) do
    attrs
    |> Enum.into(%{
      license_plate: unique_vehicle_license_plate(),
      active: true
    })
    |> Map.put_new_lazy(:type_id, fn ->
      type = VehiclesFixtures.type_fixture()
      type.id
    end)
    |> Map.put_new_lazy(:model_id, fn ->
      model = VehiclesFixtures.model_fixture()
      model.id
    end)
    |> Map.put_new_lazy(:color_id, fn ->
      color = VehiclesFixtures.color_fixture()
      color.id
    end)
  end

  def vehicle_fixture(attrs \\ %{}) do
    {:ok, vehicle} =
      attrs
      |> valid_vehicle_attributes()
      |> Customers.create_vehicle()

    vehicle
  end

  def valid_vehicle_driver_attributes(attrs \\ %{}) do
    attrs
    |> Enum.into(%{active: true})
    |> Map.put_new_lazy(:driver_id, fn ->
      driver = driver_fixture()
      driver.id
    end)
    |> Map.put_new_lazy(:vehicle_id, fn ->
      vehicle = vehicle_fixture()
      vehicle.id
    end)
  end

  def vehicle_driver_fixture(attrs \\ %{}) do
    {:ok, vehicle_driver} =
      attrs
      |> valid_vehicle_driver_attributes()
      |> Customers.create_vehicle_driver()

    vehicle_driver
  end
end
