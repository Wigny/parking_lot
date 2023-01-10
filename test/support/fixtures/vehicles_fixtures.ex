defmodule ParkingLot.VehiclesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ParkingLot.Vehicles` context.
  """

  @doc """
  Generate a unique color color.
  """
  def unique_color_color, do: "some color#{System.unique_integer([:positive])}"

  @doc """
  Generate a color.
  """
  def color_fixture(attrs \\ %{}) do
    {:ok, color} =
      attrs
      |> Enum.into(%{
        color: unique_color_color()
      })
      |> ParkingLot.Vehicles.create_color()

    color
  end

  @doc """
  Generate a unique brand brand.
  """
  def unique_brand_brand, do: "some brand#{System.unique_integer([:positive])}"

  @doc """
  Generate a brand.
  """
  def brand_fixture(attrs \\ %{}) do
    {:ok, brand} =
      attrs
      |> Enum.into(%{
        brand: unique_brand_brand()
      })
      |> ParkingLot.Vehicles.create_brand()

    brand
  end

  @doc """
  Generate a unique model model.
  """
  def unique_model_model, do: "some model#{System.unique_integer([:positive])}"

  @doc """
  Generate a model.
  """
  def model_fixture(attrs \\ %{}) do
    {:ok, model} =
      attrs
      |> Enum.into(%{
        model: unique_model_model()
      })
      |> ParkingLot.Vehicles.create_model()

    model
  end

  @doc """
  Generate a unique type type.
  """
  def unique_type_type, do: "some type#{System.unique_integer([:positive])}"

  @doc """
  Generate a type.
  """
  def type_fixture(attrs \\ %{}) do
    {:ok, type} =
      attrs
      |> Enum.into(%{
        type: unique_type_type()
      })
      |> ParkingLot.Vehicles.create_type()

    type
  end
end
