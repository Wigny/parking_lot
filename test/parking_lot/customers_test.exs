defmodule ParkingLot.CustomersTest do
  use ParkingLot.DataCase

  alias ParkingLot.Customers

  describe "drivers" do
    alias ParkingLot.Customers.Driver

    import ParkingLot.CustomersFixtures

    @invalid_attrs %{active: nil, cnh: nil, cpf: nil, email: nil, name: nil, phone: nil}

    test "list_drivers/0 returns all drivers" do
      driver = driver_fixture()
      assert Customers.list_drivers() == [driver]
    end

    test "get_driver!/1 returns the driver with given id" do
      driver = driver_fixture()
      assert Customers.get_driver!(driver.id) == driver
    end

    test "create_driver/1 with valid data creates a driver" do
      valid_attrs = %{
        active: true,
        cnh: "some cnh",
        cpf: "some cpf",
        email: "some email",
        name: "some name",
        phone: "some phone"
      }

      assert {:ok, %Driver{} = driver} = Customers.create_driver(valid_attrs)
      assert driver.active == true
      assert driver.cnh == "some cnh"
      assert driver.cpf == "some cpf"
      assert driver.email == "some email"
      assert driver.name == "some name"
      assert driver.phone == "some phone"
    end

    test "create_driver/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Customers.create_driver(@invalid_attrs)
    end

    test "update_driver/2 with valid data updates the driver" do
      driver = driver_fixture()

      update_attrs = %{
        active: false,
        cnh: "some updated cnh",
        cpf: "some updated cpf",
        email: "some updated email",
        name: "some updated name",
        phone: "some updated phone"
      }

      assert {:ok, %Driver{} = driver} = Customers.update_driver(driver, update_attrs)
      assert driver.active == false
      assert driver.cnh == "some updated cnh"
      assert driver.cpf == "some updated cpf"
      assert driver.email == "some updated email"
      assert driver.name == "some updated name"
      assert driver.phone == "some updated phone"
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
