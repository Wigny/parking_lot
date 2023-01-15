defmodule ParkingLot.Vehicles.Color do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime]

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
