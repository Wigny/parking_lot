defmodule ParkingLot.Vehicles.Brand do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime]

  schema "vehicle_brands" do
    field :brand, :string
    has_many :models, ParkingLot.Vehicles.Model

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
