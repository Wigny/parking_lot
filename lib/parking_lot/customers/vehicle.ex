defmodule ParkingLot.Customers.Vehicle do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias ParkingLot.Vehicles

  schema "vehicles" do
    field :license_plate, :string
    belongs_to :model, Vehicles.Model
    belongs_to :color, Vehicles.Color
    field :active, :boolean, default: true

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
  end
end
