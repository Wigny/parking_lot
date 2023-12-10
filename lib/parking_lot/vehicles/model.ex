defmodule ParkingLot.Vehicles.Model do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "vehicle_models" do
    field :name, :string
    belongs_to :brand, ParkingLot.Vehicles.Brand
    belongs_to :type, ParkingLot.Vehicles.Type

    timestamps type: :utc_datetime
  end

  @doc false
  def changeset(model, attrs) do
    model
    |> cast(attrs, [:name, :brand_id, :type_id])
    |> validate_required([:name, :brand_id, :type_id])
    |> unique_constraint(:name)
    |> assoc_constraint(:brand)
    |> assoc_constraint(:type)
  end
end
