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
    |> Repo.preload(:vehicle)
  end

  def create_parking(attrs \\ %{}) do
    %Parking{}
    |> Parking.changeset(attrs)
    |> Repo.insert()
  end

  def update_parking(%Parking{} = parking, attrs) do
    parking
    |> Parking.changeset(attrs)
    |> Repo.update()
  end

  def change_parking(%Parking{} = parking, attrs \\ %{}) do
    Parking.changeset(parking, attrs)
  end
end
