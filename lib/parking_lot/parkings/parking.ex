defmodule ParkingLot.Parkings.Parking do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [
    type: :utc_datetime,
    inserted_at_source: :inserted_at,
    updated_at_source: :updated_at
  ]

  schema "parkings" do
    belongs_to :vehicle, ParkingLot.Customers.Vehicle

    timestamps inserted_at: :entered_at, updated_at: :left_at
  end

  @doc false
  def changeset(parking, attrs) do
    parking
    |> cast(attrs, [:vehicle_id])
    |> validate_required([:vehicle_id])
  end
end
