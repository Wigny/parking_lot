defmodule ParkingLot.Parkings do
  @moduledoc """
  The Parkings context.
  """

  import Ecto.Query, warn: false
  alias ParkingLot.Repo

  alias ParkingLot.Parkings.Parking

  def list_parkings do
    Parking
    |> Repo.all()
    |> preload_parking()
  end

  def get_parking!(id) do
    Parking
    |> Repo.get!(id)
    |> preload_parking()
  end

  def create_parking(attrs \\ %{}) do
    %Parking{}
    |> Parking.changeset(attrs)
    |> Repo.insert()
    |> preload_parking()
  end

  def update_parking(%Parking{} = parking, attrs) do
    parking
    |> Parking.changeset(attrs)
    |> Repo.update()
  end

  def delete_parking(%Parking{} = parking) do
    Repo.delete(parking)
  end

  def change_parking(%Parking{} = parking, attrs \\ %{}) do
    Parking.changeset(parking, attrs)
  end

  def preload_parking({:ok, parking}) do
    {:ok, preload_parking(parking)}
  end

  def preload_parking({:error, changeset}) do
    {:error, changeset}
  end

  def preload_parking(parking) do
    Repo.preload(parking, :vehicle)
  end
end
