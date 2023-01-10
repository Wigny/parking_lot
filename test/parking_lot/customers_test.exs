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
end
