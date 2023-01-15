defmodule ParkingLot.Vehicles.Brand do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime]

  schema "vehicle_brands" do
    field :name, :string
    has_many :models, ParkingLot.Vehicles.Model

    timestamps()
  end

  @doc false
  def changeset(brand, attrs) do
    brand
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
