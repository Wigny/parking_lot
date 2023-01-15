defmodule ParkingLot.Vehicles.Color do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime]

  schema "vehicle_colors" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(color, attrs) do
    color
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
