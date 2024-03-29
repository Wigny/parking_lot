defmodule ParkingLot.Vehicles.Type do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "vehicle_types" do
    field :name, :string

    timestamps type: :utc_datetime
  end

  @doc false
  def changeset(type, attrs) do
    type
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
