defmodule ParkingLot.Parkings do
  @moduledoc """
  The Parkings context.
  """

  import Ecto.Query, warn: false
  alias ParkingLot.Repo

  alias ParkingLot.Parkings.Parking

  def get_last_parking(query, order_by) when is_list(query) do
    Parking
    |> where(^query)
    |> last(order_by)
    |> Repo.one()
  end

  def list_parkings do
    Parking
    |> Repo.all()
    |> Repo.preload(:vehicle)
  end

  def register_parking(attrs \\ %{}) do
    %Parking{}
    |> Parking.changeset(attrs)
    |> Repo.insert()
  end
end
