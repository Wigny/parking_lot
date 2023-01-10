defmodule ParkingLot.Vehicles.Brand do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vehicle_brands" do
    field :brand, :string

    timestamps()
  end

  @doc false
  def changeset(brand, attrs) do
    brand
    |> cast(attrs, [:brand])
    |> validate_required([:brand])
    |> unique_constraint(:brand)
  end
end
