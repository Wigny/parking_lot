defmodule ParkingLot.VehiclesTest do
  use ParkingLot.DataCase

  alias ParkingLot.Vehicles

  describe "vehicle_colors" do
    import ParkingLot.VehiclesFixtures

    test "list_colors/0 returns all vehicle_colors" do
      assert colors = Vehicles.list_colors()
      assert length(colors) == 16
    end

    test "get_color!/1 returns the color with given id" do
      color = default_color()
      assert Vehicles.get_color!(color.id) == color
    end
  end

  describe "vehicle_brands" do
    alias ParkingLot.Vehicles.Brand

    import ParkingLot.VehiclesFixtures

    @invalid_attrs %{name: nil}

    test "list_brands/0 returns all vehicle_brands" do
      brand = brand_fixture()
      assert Vehicles.list_brands() == [brand]
    end

    test "get_brand!/1 returns the brand with given id" do
      brand = brand_fixture()
      assert Vehicles.get_brand!(brand.id) == brand
    end

    test "create_brand/1 with valid data creates a brand" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Brand{} = brand} = Vehicles.create_brand(valid_attrs)
      assert brand.name == "some name"
    end

    test "create_brand/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Vehicles.create_brand(@invalid_attrs)
    end

    test "update_brand/2 with valid data updates the brand" do
      brand = brand_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Brand{} = brand} = Vehicles.update_brand(brand, update_attrs)
      assert brand.name == "some updated name"
    end

    test "update_brand/2 with invalid data returns error changeset" do
      brand = brand_fixture()
      assert {:error, %Ecto.Changeset{}} = Vehicles.update_brand(brand, @invalid_attrs)
      assert brand == Vehicles.get_brand!(brand.id)
    end

    test "delete_brand/1 deletes the brand" do
      brand = brand_fixture()
      assert {:ok, %Brand{}} = Vehicles.delete_brand(brand)
      assert_raise Ecto.NoResultsError, fn -> Vehicles.get_brand!(brand.id) end
    end

    test "change_brand/1 returns a brand changeset" do
      brand = brand_fixture()
      assert %Ecto.Changeset{} = Vehicles.change_brand(brand)
    end
  end

  describe "vehicle_models" do
    alias ParkingLot.Vehicles.Model

    import ParkingLot.VehiclesFixtures

    @invalid_attrs %{name: nil}

    test "list_models/0 returns all vehicle_models" do
      model = model_fixture()
      assert Vehicles.list_models() == [model]
    end

    test "get_model!/1 returns the model with given id" do
      model = model_fixture()
      assert Vehicles.get_model!(model.id) == model
    end

    test "create_model/1 with valid data creates a model" do
      valid_attrs = valid_model_attributes()

      assert {:ok, %Model{} = model} = Vehicles.create_model(valid_attrs)
      assert model.name == valid_attrs.name
      assert model.brand_id == valid_attrs.brand_id
      assert model.type_id == valid_attrs.type_id
    end

    test "create_model/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Vehicles.create_model(@invalid_attrs)
    end

    test "update_model/2 with valid data updates the model" do
      model = model_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Model{} = model} = Vehicles.update_model(model, update_attrs)
      assert model.name == "some updated name"
    end

    test "update_model/2 with invalid data returns error changeset" do
      model = model_fixture()
      assert {:error, %Ecto.Changeset{}} = Vehicles.update_model(model, @invalid_attrs)
      assert model == Vehicles.get_model!(model.id)
    end

    test "delete_model/1 deletes the model" do
      model = model_fixture()
      assert {:ok, %Model{}} = Vehicles.delete_model(model)
      assert_raise Ecto.NoResultsError, fn -> Vehicles.get_model!(model.id) end
    end

    test "change_model/1 returns a model changeset" do
      model = model_fixture()
      assert %Ecto.Changeset{} = Vehicles.change_model(model)
    end
  end

  describe "vehicle_types" do
    import ParkingLot.VehiclesFixtures

    test "list_types/0 returns all vehicle_types" do
      assert types = Vehicles.list_types()
      assert length(types) == 22
    end

    test "get_type!/1 returns the type with given id" do
      type = default_type()
      assert Vehicles.get_type!(type.id) == type
    end
  end
end
