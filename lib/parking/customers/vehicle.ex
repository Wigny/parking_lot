defmodule Parking.Customers.Vehicle do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime]

  schema "vehicles" do
    field :license_plate, :string
    field :deleted_at, :utc_datetime

    timestamps()
  end

  def creation_changeset(vehicle, attrs) do
    vehicle
    |> cast(attrs, [:license_plate, :deleted_at])
    |> validate_required([:license_plate])
    |> validate_format(
      :license_plate,
      ~r/(?<legacy>[A-Z]{3}-?[0-9]{4})|(?<mercosul>[A-Z]{3}[0-9][A-Z][0-9]{2})/
    )
    |> unique_constraint(:license_plate)
  end

  defdelegate deletion_changeset(vehicle), to: Parking.Changeset, as: :mark_deletion
end
