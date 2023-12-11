defmodule ParkingLot.Vehicles do
  @moduledoc """
  The Vehicles context.
  """

  import Ecto.Query, warn: false
  alias ParkingLot.Repo

  alias ParkingLot.Vehicles.{Brand, Color, Model, Type}

  def list_colors do
    Repo.all(Color)
  end

  def get_color!(id), do: Repo.get!(Color, id)

  def list_brands do
    Repo.all(Brand)
  end

  def get_brand!(id), do: Repo.get!(Brand, id)

  def create_brand(attrs \\ %{}) do
    %Brand{}
    |> Brand.changeset(attrs)
    |> Repo.insert()
  end

  def update_brand(%Brand{} = brand, attrs) do
    brand
    |> Brand.changeset(attrs)
    |> Repo.update()
  end

  def delete_brand(%Brand{} = brand) do
    brand
    |> Brand.changeset(%{})
    |> Repo.delete()
  end

  def change_brand(%Brand{} = brand, attrs \\ %{}) do
    Brand.changeset(brand, attrs)
  end

  def list_models do
    Model
    |> Repo.all()
    |> preload_model()
  end

  def get_model!(id) do
    Model
    |> Repo.get!(id)
    |> preload_model()
  end

  def create_model(attrs \\ %{}) do
    %Model{}
    |> Model.changeset(attrs)
    |> Repo.insert()
    |> preload_model()
  end

  def update_model(%Model{} = model, attrs) do
    model
    |> Model.changeset(attrs)
    |> Repo.update()
    |> preload_model()
  end

  def delete_model(%Model{} = model) do
    model
    |> Model.changeset(%{})
    |> Repo.delete()
  end

  def change_model(%Model{} = model, attrs \\ %{}) do
    Model.changeset(model, attrs)
  end

  def preload_model({:ok, model}) do
    {:ok, preload_model(model)}
  end

  def preload_model({:error, changeset}) do
    {:error, changeset}
  end

  def preload_model(model) do
    Repo.preload(model, [:brand, :type])
  end

  def list_types do
    Repo.all(Type)
  end

  def get_type!(id), do: Repo.get!(Type, id)
end
