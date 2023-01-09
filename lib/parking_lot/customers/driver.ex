defmodule ParkingLot.Customers.Driver do
  use Ecto.Schema
  import Ecto.Changeset

  schema "drivers" do
    field :active, :boolean, default: false
    field :cnh, :string
    field :cpf, :string
    field :email, :string
    field :name, :string
    field :phone, :string

    timestamps()
  end

  @doc false
  def changeset(driver, attrs) do
    driver
    |> cast(attrs, [:name, :cpf, :cnh, :email, :phone, :active])
    |> validate_required([:name, :cpf, :cnh, :email, :phone, :active])
    |> unique_constraint(:phone)
    |> unique_constraint(:email)
    |> unique_constraint(:cnh)
    |> unique_constraint(:cpf)
  end
end
