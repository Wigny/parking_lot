defmodule ParkingLot.Cameras.Camera do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  import ParkingLot.Changeset

  schema "cameras" do
    field :type, Ecto.Enum, values: [:entry, :leave]
    field :uri, ParkingLot.Type.URI
    field :active, :boolean

    timestamps type: :utc_datetime
  end

  @doc false
  def changeset(camera, attrs) do
    camera
    |> cast(attrs, [:type, :uri, :active])
    |> validate_required([:type, :uri, :active])
    |> validate_uri(:uri)
    |> unique_constraint(:uri)
    |> unique_constraint(:type)
  end
end
