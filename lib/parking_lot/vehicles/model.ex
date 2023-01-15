defmodule ParkingLot.Vehicles.Model do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime]

  schema "vehicle_models" do
    field :name, :string
    belongs_to :brand, ParkingLot.Vehicles.Brand

    timestamps()
  end

  @doc false
  def changeset(model, attrs) do
    model
    |> cast(attrs, [:name, :brand_id])
    |> validate_required([:name, :brand_id])
    |> unique_constraint(:name)
    |> assoc_constraint(:brand)
  end
end
