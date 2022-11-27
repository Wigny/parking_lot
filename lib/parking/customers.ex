defmodule Parking.Customers do
  @moduledoc """
  The Customers context.
  """

  import Ecto.Query
  import Parking.Query, only: [where_include_deleted: 2]
  alias Parking.Repo
  alias Parking.Customers.Vehicle

  def list_vehicles(opts \\ []) do
    include_deleted = Keyword.get(opts, :include_deleted, false)

    Vehicle
    |> where_include_deleted(include_deleted)
    |> Repo.all()
  end

  def get_vehicle!(id) do
    Vehicle
    |> where(id: ^id)
    |> where_include_deleted(false)
    |> Repo.one!()
  end

  def create_vehicle(attrs \\ %{}) do
    %Vehicle{}
    |> Vehicle.creation_changeset(attrs)
    |> Repo.insert()
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
