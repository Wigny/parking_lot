defmodule ParkingLot.Parkings.Parking do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "parkings" do
    belongs_to :vehicle, ParkingLot.Customers.Vehicle
    field :entered_at, :utc_datetime
    field :left_at, :utc_datetime

    timestamps type: :utc_datetime
  end

  @doc false
  def changeset(parking, attrs) do
    parking
    |> cast(attrs, [:vehicle_id, :entered_at, :left_at])
    |> validate_required([:vehicle_id, :entered_at])
  end
end
