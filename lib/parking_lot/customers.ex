defmodule ParkingLot.Customers do
  @moduledoc """
  The Customers context.
  """

  import Ecto.Query
  import ParkingLot.Query, only: [where_include_deleted: 2]
  alias ParkingLot.Repo

  alias ParkingLot.Customers.{Driver, Vehicle}

  def list_drivers(opts \\ []) do
    include_deleted = Keyword.get(opts, :include_deleted, false)

    Driver
    |> where_include_deleted(include_deleted)
    |> Repo.all()
  end

  def get_driver!(id) do
    Driver
    |> where(id: ^id)
    |> where_include_deleted(false)
    |> Repo.one!()
  end

  def create_driver(attrs \\ %{}) do
    %Driver{}
    |> Driver.creation_changeset(attrs)
    |> Repo.insert(
      on_conflict: {:replace, [:deleted_at]},
      returning: true,
      conflict_target: [:cpf]
    )
  end

  def delete_driver(%Driver{} = driver) do
    driver
    |> Driver.deletion_changeset()
    |> Repo.update()
  end

  def change_driver(%Driver{} = driver, attrs \\ %{}) do
    Driver.creation_changeset(driver, attrs)
  end

  def list_vehicles(opts \\ []) do
    include_deleted = Keyword.get(opts, :include_deleted, false)

    Vehicle
    |> where_include_deleted(include_deleted)
    |> Repo.all()
  end

  def get_vehicle!(id) when is_binary(id) do
    Vehicle
    |> where(id: ^id)
    |> where_include_deleted(false)
    |> Repo.one()
  end

  def get_vehicle(query) when is_list(query) do
    Vehicle
    |> where(^query)
    |> where_include_deleted(false)
    |> Repo.one()
  end

  def create_vehicle(attrs \\ %{}) do
    %Vehicle{}
    |> Vehicle.creation_changeset(attrs)
    |> Repo.insert(
      on_conflict: {:replace, [:deleted_at]},
      returning: true,
      conflict_target: [:license_plate]
    )
  end

  def delete_vehicle(%Vehicle{} = vehicle) do
    vehicle
    |> Vehicle.deletion_changeset()
    |> Repo.update()
  end

  def change_vehicle(%Vehicle{} = vehicle, attrs \\ %{}) do
    Vehicle.creation_changeset(vehicle, attrs)
  end
end
