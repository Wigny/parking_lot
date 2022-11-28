defmodule Parking.CustomersTest do
  use Parking.DataCase

  alias Parking.Customers

  describe "drivers" do
    alias Parking.Customers.Driver

    import Parking.CustomersFixtures

    @invalid_attrs %{name: nil, cpf: nil, cnh: nil}

    test "list_drivers/0 returns all drivers" do
      driver = driver_fixture()
      assert Customers.list_drivers() == [driver]
    end

    test "get_driver!/1 returns the driver with given id" do
      driver = driver_fixture()
      assert Customers.get_driver!(driver.id) == driver
    end

    test "create_driver/1 with valid data creates a driver" do
      valid_attrs = valid_driver_attributes()

      assert {:ok, %Driver{} = driver} = Customers.create_driver(valid_attrs)
      assert driver.cnh == valid_attrs.cnh
      assert driver.cpf == valid_attrs.cpf
      assert driver.deleted_at == nil
      assert driver.name == "some name"
    end

    test "create_driver/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Customers.create_driver(@invalid_attrs)
    end

    test "create_driver/1 with deleted driver data reanables the entry" do
      deleted_driver = driver_fixture(deleted_at: DateTime.utc_now())
      valid_attrs = valid_driver_attributes(%{cpf: deleted_driver.cpf})

      assert {:ok, %Driver{} = driver} = Customers.create_driver(valid_attrs)
      assert driver.cnh == deleted_driver.cnh
      assert driver.cpf == deleted_driver.cpf
      assert driver.deleted_at == nil
      assert driver.name == deleted_driver.name
    end

    test "delete_driver/1 deletes the driver" do
      driver = driver_fixture()
      assert {:ok, %Driver{}} = Customers.delete_driver(driver)
      assert_raise Ecto.NoResultsError, fn -> Customers.get_driver!(driver.id) end
    end

    test "change_driver/1 returns a driver changeset" do
      driver = driver_fixture()
      assert %Ecto.Changeset{} = Customers.change_driver(driver)
    end
  end

  describe "vehicles" do
    alias Parking.Customers.Vehicle

    import Parking.CustomersFixtures

    @invalid_attrs %{license_plate: nil}

    test "list_vehicles/0 returns all vehicles" do
      vehicle = vehicle_fixture()
      assert Customers.list_vehicles() == [vehicle]
    end

    test "get_vehicle!/1 returns the vehicle with given id" do
      vehicle = vehicle_fixture()
      assert Customers.get_vehicle!(vehicle.id) == vehicle
    end

    test "create_vehicle/1 with valid data creates a vehicle" do
      valid_attrs = valid_vehicle_attributes()

      assert {:ok, %Vehicle{} = vehicle} = Customers.create_vehicle(valid_attrs)
      assert vehicle.license_plate == valid_attrs.license_plate
      assert vehicle.deleted_at == nil
    end

    test "create_vehicle/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Customers.create_vehicle(@invalid_attrs)
    end

    test "create_vehicle/1 with deleted vehicle data reanables the entry" do
      deleted_vehicle = vehicle_fixture(deleted_at: DateTime.utc_now())
      valid_attrs = valid_vehicle_attributes(%{license_plate: deleted_vehicle.license_plate})

      assert {:ok, %Vehicle{} = vehicle} = Customers.create_vehicle(valid_attrs)
      assert vehicle.id == deleted_vehicle.id
      assert vehicle.license_plate == deleted_vehicle.license_plate
      assert vehicle.deleted_at == nil
    end

    test "delete_vehicle/1 deletes the vehicle" do
      vehicle = vehicle_fixture()
      assert {:ok, %Vehicle{}} = Customers.delete_vehicle(vehicle)
      assert_raise Ecto.NoResultsError, fn -> Customers.get_vehicle!(vehicle.id) end
    end

    test "change_vehicle/1 returns a vehicle changeset" do
      vehicle = vehicle_fixture()
      assert %Ecto.Changeset{} = Customers.change_vehicle(vehicle)
    end
  end
end
