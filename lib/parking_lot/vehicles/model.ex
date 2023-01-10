defmodule ParkingLot.Vehicles.Model do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vehicle_models" do
    field :model, :string
    field :brand_id, :id

    timestamps()
  end

  @doc false
  def changeset(model, attrs) do
    model
    |> cast(attrs, [:model])
    |> validate_required([:model])
    |> unique_constraint(:model)
  end
end
