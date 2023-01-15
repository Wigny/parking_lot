defmodule ParkingLot.Customers.VehicleDriver do
  use Ecto.Schema
  import Ecto.Changeset
  alias ParkingLot.Customers.{Driver, Vehicle}

  @timestamps_opts [type: :utc_datetime]

  schema "vehicles_drivers" do
    belongs_to :driver, Driver
    belongs_to :vehicle, Vehicle
    field :active, :boolean, default: true

    timestamps()
  end

  @doc false
  def changeset(vehicle_driver, attrs) do
    vehicle_driver
    |> cast(attrs, [:active, :driver_id, :vehicle_id])
    |> validate_required([:active, :driver_id, :vehicle_id])
    |> assoc_constraint(:driver)
    |> assoc_constraint(:vehicle)
    |> unique_constraint([:driver, :vehicle])
  end
end
