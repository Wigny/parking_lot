defmodule ParkingLot.Customers.Vehicle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vehicles" do
    field :active, :boolean, default: false
    field :license_plate, :string
    field :type_id, :id
    field :model_id, :id
    field :color_id, :id

    timestamps()
  end

  @doc false
  def changeset(vehicle, attrs) do
    vehicle
    |> cast(attrs, [:license_plate, :active])
    |> validate_required([:license_plate, :active])
    |> unique_constraint(:license_plate)
  end
end
