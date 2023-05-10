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
    |> validate_length(:email, max: 160)
    |> validate_length(:phone, is: 11)
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
    |> validate_format(:phone, ~r/^\d+$/)
    |> validate_digits(:cpf, length: 11, weights: [Enum.to_list(10..2), Enum.to_list(11..2)])
    |> validate_digits(:cnh, length: 11, weights: [Enum.to_list(2..10), Enum.concat(3..11, [2])])
    |> unique_constraint(:cpf)
    |> unique_constraint(:cnh)
    |> unique_constraint(:email)
    |> unique_constraint(:phone)
  end
end
