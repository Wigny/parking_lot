defmodule ParkingLot.Cameras.Camera do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cameras" do
    field :type, Ecto.Enum, values: [:internal, :external]
    field :uri, :string

    timestamps()
  end

  @doc false
  def changeset(camera, attrs) do
    camera
    |> cast(attrs, [:type, :uri])
    |> validate_required([:type, :uri])
    |> unique_constraint(:uri)
    |> unique_constraint(:type)
  end
end
