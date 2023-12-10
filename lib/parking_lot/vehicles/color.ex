defmodule ParkingLot.Vehicles.Color do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "vehicle_colors" do
    field :name, :string

    timestamps type: :utc_datetime
  end

  @doc false
  def changeset(color, attrs) do
    color
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
