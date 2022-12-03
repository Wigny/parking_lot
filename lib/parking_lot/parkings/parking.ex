defmodule ParkingLot.Parkings.Parking do
  use Ecto.Schema
  import Ecto.Changeset
  alias ParkingLot.Customers.Vehicle

  schema "parkings" do
    belongs_to :vehicle, Vehicle

    timestamps inserted_at: :entered_at, updated_at: :left_at
  end

  @doc false
  def changeset(parking, attrs) do
    parking
    |> cast(attrs, [:vehicle_id])
    |> validate_required([:vehicle_id])
    |> assoc_constraint(:vehicle)
  end
end
