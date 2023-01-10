defmodule ParkingLot.Customers.Driver do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  import ParkingLot.Changeset

  @timestamps_opts [type: :utc_datetime]

  schema "drivers" do
    field :name, :string
    field :cpf, :string
    field :cnh, :string
    field :email, :string
    field :phone, :string
    field :active, :boolean, default: true

    timestamps()
  end

  def changeset(driver, attrs) do
    driver
    |> cast(attrs, [:name, :cpf, :cnh, :email, :phone, :active])
    |> validate_required([:name, :cpf, :cnh, :email])
    |> validate_length(:cpf, is: 11)
    |> validate_length(:cnh, is: 11)
    |> validate_length(:phone, is: 11)
    |> validate_check_digit(:cpf)
    |> validate_check_digit(:cnh)
    |> validate_format(:email, ~r/@/)
    |> validate_format(:phone, ~r/^\d+$/)
    |> unique_constraint(:cpf)
    |> unique_constraint(:cnh)
    |> unique_constraint(:email)
    |> unique_constraint(:phone)
  end
end
