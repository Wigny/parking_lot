defmodule ParkingLot.Accounts.User do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime]

  schema "users" do
    field :email, :string
    field :admin, :boolean
    has_many :sessions, ParkingLot.Accounts.Session

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :admin])
    |> validate_required([:email])
    |> validate_email(:email)
    |> unique_constraint(:email)
  end
end
