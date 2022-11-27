defmodule Parking.CustomersTest do
  use Parking.DataCase

  alias Parking.Customers

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
    end

    test "create_vehicle/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Customers.create_vehicle(@invalid_attrs)
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
