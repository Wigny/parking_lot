defmodule ParkingLot.VehiclesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ParkingLot.Vehicles` context.
  """

  alias ParkingLot.Vehicles

  def default_color do
    Vehicles.get_color!(1)
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
    |> Map.put_new_lazy(:type_id, fn ->
      type = default_type()
      type.id
    end)
  end

  def model_fixture(attrs \\ %{}) do
    {:ok, model} =
      attrs
      |> valid_model_attributes()
      |> Vehicles.create_model()

    model
  end

  def default_type do
    Vehicles.get_type!(1)
  end
end
