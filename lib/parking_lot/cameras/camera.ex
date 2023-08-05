defmodule ParkingLot.Cameras.Camera do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  import ParkingLot.Changeset

  @timestamps_opts [type: :utc_datetime]

  schema "cameras" do
    field :type, Ecto.Enum, values: [:internal, :external]
    field :uri, ParkingLot.Type.URI
    field :on, :boolean

    timestamps()
  end

  @doc false
  def changeset(camera, attrs) do
    camera
    |> cast(attrs, [:type, :uri, :on])
    |> validate_required([:type, :uri, :on])
    |> validate_uri(:uri)
    |> unique_constraint(:uri)
    |> unique_constraint(:type)
  end
end
