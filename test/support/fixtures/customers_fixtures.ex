defmodule ParkingLot.CustomersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ParkingLot.Customers` context.
  """

  alias ParkingLot.Customers
  alias ParkingLot.Digits
  alias ParkingLot.Document
  alias ParkingLot.Phone
  alias ParkingLot.VehiclesFixtures

  def unique_driver_cpf do
    base = random_list(9, 0..9)
    check_digits = Document.CPF.check_digits(base)

    {:ok, document} = Document.CPF.new(Enum.concat(base, check_digits))
    document
  end

  def unique_driver_cnh do
    base = random_list(9, 0..9)
    check_digits = Document.CNH.check_digits(base)

    {:ok, document} = Document.CNH.new(Enum.concat(base, check_digits))
    document
  end

  def unique_driver_email do
    "driver#{System.unique_integer([:positive])}@example.com"
  end

  def unique_driver_phone do
    digits = Enum.concat([5, 5, 1, 1], random_list(9, 0..9))

    Phone.new!(<<?+, Digits.to_string(digits)::binary>>)
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

  def unique_vehicle_license_plate(version \\ :mercosur)

  def unique_vehicle_license_plate(:mercosur) do
    letters = Enum.map(?A..?Z, &<<&1::utf8>>)
    numbers = Enum.map(?0..?9, &<<&1::utf8>>)

    Enum.join([
      random_list(3, letters),
      random_list(1, numbers),
      random_list(1, letters),
      random_list(2, numbers)
    ])
  end

  def unique_vehicle_license_plate(:legacy) do
    letters = Enum.map(?A..?Z, &<<&1::utf8>>)
    numbers = Enum.map(?0..?9, &<<&1::utf8>>)

    Enum.join([
      random_list(3, letters),
      random_list(4, numbers)
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

  defp random_list(length, elements) do
    generator = fn -> Enum.random(elements) end

    generator
    |> Stream.repeatedly()
    |> Enum.take(length)
  end
end
