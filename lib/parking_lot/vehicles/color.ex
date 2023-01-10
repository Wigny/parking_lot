defmodule ParkingLot.Vehicles.Color do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vehicle_colors" do
    field :color, :string

    timestamps()
  end

  @doc false
  def changeset(color, attrs) do
    color
    |> cast(attrs, [:color])
    |> validate_required([:color])
    |> unique_constraint(:color)
  end
end
