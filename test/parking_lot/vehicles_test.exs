defmodule ParkingLot.VehiclesTest do
  use ParkingLot.DataCase

  alias ParkingLot.Vehicles

  describe "vehicle_colors" do
    alias ParkingLot.Vehicles.Color

    import ParkingLot.VehiclesFixtures

    @invalid_attrs %{name: nil}

    test "list_colors/0 returns all vehicle_colors" do
      color = color_fixture()
      assert Vehicles.list_colors() == [color]
    end

    test "get_color!/1 returns the color with given id" do
      color = color_fixture()
      assert Vehicles.get_color!(color.id) == color
    end

    test "create_color/1 with valid data creates a color" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Color{} = color} = Vehicles.create_color(valid_attrs)
      assert color.name == "some name"
    end

    test "create_color/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Vehicles.create_color(@invalid_attrs)
    end

    test "update_color/2 with valid data updates the color" do
      color = color_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Color{} = color} = Vehicles.update_color(color, update_attrs)
      assert color.name == "some updated name"
    end

    test "update_color/2 with invalid data returns error changeset" do
      color = color_fixture()
      assert {:error, %Ecto.Changeset{}} = Vehicles.update_color(color, @invalid_attrs)
      assert color == Vehicles.get_color!(color.id)
    end

    test "delete_color/1 deletes the color" do
      color = color_fixture()
      assert {:ok, %Color{}} = Vehicles.delete_color(color)
      assert_raise Ecto.NoResultsError, fn -> Vehicles.get_color!(color.id) end
    end

    test "change_color/1 returns a color changeset" do
      color = color_fixture()
      assert %Ecto.Changeset{} = Vehicles.change_color(color)
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
    alias ParkingLot.Vehicles.Type

    import ParkingLot.VehiclesFixtures

    @invalid_attrs %{name: nil}

    test "list_types/0 returns all vehicle_types" do
      type = type_fixture()
      assert Vehicles.list_types() == [type]
    end

    test "get_type!/1 returns the type with given id" do
      type = type_fixture()
      assert Vehicles.get_type!(type.id) == type
    end

    test "create_type/1 with valid data creates a type" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Type{} = type} = Vehicles.create_type(valid_attrs)
      assert type.name == "some name"
    end

    test "create_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Vehicles.create_type(@invalid_attrs)
    end

    test "update_type/2 with valid data updates the type" do
      type = type_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Type{} = type} = Vehicles.update_type(type, update_attrs)
      assert type.name == "some updated name"
    end

    test "update_type/2 with invalid data returns error changeset" do
      type = type_fixture()
      assert {:error, %Ecto.Changeset{}} = Vehicles.update_type(type, @invalid_attrs)
      assert type == Vehicles.get_type!(type.id)
    end

    test "delete_type/1 deletes the type" do
      type = type_fixture()
      assert {:ok, %Type{}} = Vehicles.delete_type(type)
      assert_raise Ecto.NoResultsError, fn -> Vehicles.get_type!(type.id) end
    end

    test "change_type/1 returns a type changeset" do
      type = type_fixture()
      assert %Ecto.Changeset{} = Vehicles.change_type(type)
    end
  end
end
