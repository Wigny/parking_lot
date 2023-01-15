defmodule ParkingLot.CustomersTest do
  use ParkingLot.DataCase

  alias ParkingLot.Customers

  describe "drivers" do
    alias ParkingLot.Customers.Driver

    import ParkingLot.CustomersFixtures

    @invalid_attrs %{name: nil, cpf: nil, cnh: nil, email: nil, phone: nil, active: nil}

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
      assert driver.name == valid_attrs.name
      assert driver.cpf == valid_attrs.cpf
      assert driver.cnh == valid_attrs.cnh
      assert driver.email == valid_attrs.email
      assert driver.phone == valid_attrs.phone
      assert driver.active == valid_attrs.active
    end

    test "create_driver/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Customers.create_driver(@invalid_attrs)
    end

    test "update_driver/2 with valid data updates the driver" do
      driver = driver_fixture()
      update_attrs = valid_driver_attributes(%{name: "some updated name", active: false})

      assert {:ok, %Driver{} = driver} = Customers.update_driver(driver, update_attrs)
      assert driver.name == update_attrs.name
      assert driver.cpf == update_attrs.cpf
      assert driver.cnh == update_attrs.cnh
      assert driver.email == update_attrs.email
      assert driver.phone == update_attrs.phone
      assert driver.active == update_attrs.active
    end

    test "update_driver/2 with invalid data returns error changeset" do
      driver = driver_fixture()
      assert {:error, %Ecto.Changeset{}} = Customers.update_driver(driver, @invalid_attrs)
      assert driver == Customers.get_driver!(driver.id)
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
    alias ParkingLot.Customers.Vehicle

    import ParkingLot.CustomersFixtures

    @invalid_attrs %{active: nil, license_plate: nil}

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
      assert vehicle.type_id == valid_attrs.type_id
      assert vehicle.model_id == valid_attrs.model_id
      assert vehicle.color_id == valid_attrs.color_id
      assert vehicle.active == true
    end

    test "create_vehicle/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Customers.create_vehicle(@invalid_attrs)
    end

    test "update_vehicle/2 with valid data updates the vehicle" do
      vehicle = vehicle_fixture()
      update_attrs = valid_vehicle_attributes(%{active: false})

      assert {:ok, %Vehicle{} = vehicle} = Customers.update_vehicle(vehicle, update_attrs)
      assert vehicle.license_plate == update_attrs.license_plate
      assert vehicle.type_id == update_attrs.type_id
      assert vehicle.model_id == update_attrs.model_id
      assert vehicle.color_id == update_attrs.color_id
      assert vehicle.active == false
    end

    test "update_vehicle/2 with invalid data returns error changeset" do
      vehicle = vehicle_fixture()
      assert {:error, %Ecto.Changeset{}} = Customers.update_vehicle(vehicle, @invalid_attrs)
      assert vehicle == Customers.get_vehicle!(vehicle.id)
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
