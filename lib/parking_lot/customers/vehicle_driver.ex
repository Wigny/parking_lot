defmodule ParkingLot.Customers.VehicleDriver do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias ParkingLot.Customers.{Driver, Vehicle}

  schema "vehicles_drivers" do
    belongs_to :driver, Driver
    belongs_to :vehicle, Vehicle
    field :active, :boolean, default: true

    timestamps type: :utc_datetime
  end

  @doc false
  def changeset(vehicle_driver, attrs) do
    vehicle_driver
    |> cast(attrs, [:active, :driver_id, :vehicle_id])
    |> validate_required([:active, :driver_id, :vehicle_id])
    |> assoc_constraint(:driver)
    |> assoc_constraint(:vehicle)
    |> unique_constraint([:driver_id, :vehicle_id])
  end
end
