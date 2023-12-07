defmodule ParkingLot.Parkings do
  @moduledoc """
  The Parkings context.
  """

  import Ecto.Query, warn: false
  alias ParkingLot.Repo

  alias ParkingLot.Parkings.Parking

  def list_parkings(where \\ [], opts \\ []) when is_list(where) do
    Parking
    |> where(^where)
    |> query(opts)
    |> Repo.all()
    |> preload_parking()
  end

  def get_parking!(id) do
    Parking
    |> Repo.get!(id)
    |> preload_parking()
  end

  def get_last_parking(where, order_by \\ nil) when is_list(where) do
    Parking
    |> where(^where)
    |> last(order_by)
    |> Repo.one()
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
    Repo.preload(parking, vehicle: [[model: [:brand]], :color])
  end

  # register the car entry
  def register_parking(:entry, vehicle) do
    last_parking = get_last_parking(vehicle_id: vehicle.id)

    if match?(%{left_at: nil}, last_parking) do
      {:error, :already_entered}
    else
      create_parking(%{vehicle_id: vehicle.id, entered_at: DateTime.utc_now()})
    end
  end

  # register the car exit
  def register_parking(:leave, vehicle) do
    last_parking = get_last_parking(vehicle_id: vehicle.id)

    if match?(%{left_at: nil}, last_parking) do
      update_parking(last_parking, %{left_at: DateTime.utc_now()})
    else
      {:error, :already_left}
    end
  end

  defp query(q, criteria) do
    Enum.reduce(criteria, q, fn
      {:limit, limit}, query -> limit(query, ^limit)
      {:order, order}, query -> order_by(query, ^order)
    end)
  end
end
