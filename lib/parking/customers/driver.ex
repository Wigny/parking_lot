defmodule Parking.Customers.Driver do
  use Ecto.Schema
  import Ecto.Changeset
  import Parking.Changeset, only: [validate_check_digit: 2]

  @timestamps_opts [type: :utc_datetime]

  schema "drivers" do
    field :name, :string
    field :cpf, :string
    field :cnh, :string
    field :deleted_at, :utc_datetime

    timestamps()
  end

  def creation_changeset(driver, attrs) do
    driver
    |> cast(attrs, [:name, :cpf, :cnh, :deleted_at])
    |> validate_required([:name, :cpf, :cnh])
    |> unique_constraint(:cpf)
    |> unique_constraint(:cnh)
    |> validate_length(:cpf, is: 11)
    |> validate_length(:cnh, is: 11)
    |> validate_check_digit(:cpf)
    |> validate_check_digit(:cnh)
  end

  defdelegate deletion_changeset(vehicle), to: Parking.Changeset, as: :mark_deletion
end
