defmodule ParkingLot.VehiclesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ParkingLot.Vehicles` context.
  """

  alias ParkingLot.Vehicles

  def unique_color_name, do: "some name#{System.unique_integer([:positive])}"

  def color_fixture(attrs \\ %{}) do
    {:ok, color} =
      attrs
      |> Enum.into(%{name: unique_color_name()})
      |> Vehicles.create_color()

    color
  end

  def unique_brand_name, do: "some name#{System.unique_integer([:positive])}"

  def brand_fixture(attrs \\ %{}) do
    {:ok, brand} =
      attrs
      |> Enum.into(%{name: unique_brand_name()})
      |> Vehicles.create_brand()

    brand
  end

  def unique_model_name, do: "some name#{System.unique_integer([:positive])}"

  def valid_model_attributes(attrs \\ %{}) do
    attrs
    |> Enum.into(%{name: unique_model_name()})
    |> Map.put_new_lazy(:brand_id, fn ->
      brand = brand_fixture()
      brand.id
    end)
  end

  def model_fixture(attrs \\ %{}) do
    {:ok, model} =
      attrs
      |> valid_model_attributes()
      |> Vehicles.create_model()

    model
  end

  def unique_type_name, do: "some name#{System.unique_integer([:positive])}"

  def type_fixture(attrs \\ %{}) do
    {:ok, type} =
      attrs
      |> Enum.into(%{name: unique_type_name()})
      |> Vehicles.create_type()

    type
  end
end
