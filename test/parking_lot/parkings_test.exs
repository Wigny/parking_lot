defmodule ParkingLot.ParkingsTest do
  use ParkingLot.DataCase

  alias ParkingLot.Parkings

  describe "parkings" do
    alias ParkingLot.Parkings.Parking

    import ParkingLot.ParkingsFixtures

    @invalid_attrs %{vehicle_id: nil, entered_at: nil, left_at: nil}

    test "list_parkings/0 returns all parkings" do
      parking = parking_fixture()
      assert Parkings.list_parkings() == [parking]
    end

    test "get_parking!/1 returns the parking with given id" do
      parking = parking_fixture()
      assert Parkings.get_parking!(parking.id) == parking
    end

    test "create_parking/1 with valid data creates a parking" do
      valid_attrs = valid_parking_attributes()

      assert {:ok, %Parking{} = parking} = Parkings.create_parking(valid_attrs)
      assert parking.vehicle_id == valid_attrs.vehicle_id
    end

    test "create_parking/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Parkings.create_parking(@invalid_attrs)
    end

    test "update_parking/2 with valid data updates the parking" do
      parking = parking_fixture()
      update_attrs = valid_parking_attributes()

      assert {:ok, %Parking{} = parking} = Parkings.update_parking(parking, update_attrs)
      assert parking.vehicle_id == update_attrs.vehicle_id
    end

    test "update_parking/2 with invalid data returns error changeset" do
      parking = parking_fixture()
      assert {:error, %Ecto.Changeset{}} = Parkings.update_parking(parking, @invalid_attrs)
      assert parking == Parkings.get_parking!(parking.id)
    end

    test "delete_parking/1 deletes the parking" do
      parking = parking_fixture()
      assert {:ok, %Parking{}} = Parkings.delete_parking(parking)
      assert_raise Ecto.NoResultsError, fn -> Parkings.get_parking!(parking.id) end
    end

    test "change_parking/1 returns a parking changeset" do
      parking = parking_fixture()
      assert %Ecto.Changeset{} = Parkings.change_parking(parking)
    end
  end
end
