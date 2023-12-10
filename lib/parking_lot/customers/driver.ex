defmodule ParkingLot.Customers.Driver do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  import ParkingLot.Changeset

  schema "drivers" do
    field :name, :string
    field :cpf, ParkingLot.Type.Document, as: ParkingLot.Document.CPF
    field :cnh, ParkingLot.Type.Document, as: ParkingLot.Document.CNH
    field :email, :string
    field :phone, ParkingLot.Type.Phone, country: "BR"
    field :active, :boolean, default: true

    timestamps type: :utc_datetime
  end

  def changeset(driver, attrs) do
    driver
    |> cast(attrs, [:name, :cpf, :cnh, :email, :phone, :active])
    |> validate_required([:name, :cpf, :cnh, :email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
    |> validate_phone(:phone)
    |> unique_constraint(:cpf)
    |> unique_constraint(:cnh)
    |> unique_constraint(:email)
    |> unique_constraint(:phone)
  end
end
