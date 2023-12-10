defmodule ParkingLot.Vehicles.Brand do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "vehicle_brands" do
    field :name, :string
    has_many :models, ParkingLot.Vehicles.Model

    timestamps type: :utc_datetime
  end

  @doc false
  def changeset(brand, attrs) do
    brand
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> no_assoc_constraint(:models)
  end
end
