defmodule ParkingLot.Customers.Vehicle do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias ParkingLot.{Customers, Parkings, Vehicles}

  schema "vehicles" do
    field :license_plate, :string
    field :active, :boolean, default: true
    belongs_to :model, Vehicles.Model
    belongs_to :color, Vehicles.Color
    has_many :parkings, Parkings.Parking
    has_many :vehicles_drivers, Customers.VehicleDriver

    timestamps type: :utc_datetime
  end

  @doc false
  def changeset(vehicle, attrs) do
    vehicle
    |> cast(attrs, ~w[license_plate model_id color_id active]a)
    |> validate_required(~w[license_plate model_id color_id active]a)
    |> validate_length(:license_plate, is: 7)
    |> validate_format(
      :license_plate,
      ~r/(?<legacy>[A-Z]{3}-?[0-9]{4})|(?<mercosur>[A-Z]{3}[0-9][A-Z][0-9]{2})/
    )
    |> unique_constraint(:license_plate)
    |> assoc_constraint(:model)
    |> assoc_constraint(:color)
    |> no_assoc_constraint(:parkings)
    |> no_assoc_constraint(:vehicles_drivers)
  end
end
