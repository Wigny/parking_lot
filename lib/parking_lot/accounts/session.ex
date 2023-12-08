defmodule ParkingLot.Accounts.Session do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @rand_size 32

  schema "sessions" do
    field :token, :binary
    belongs_to :user, ParkingLot.Accounts.User

    timestamps updated_at: false, type: :utc_datetime
  end

  def changeset(session, attrs) do
    session
    |> cast(attrs, [:user_id])
    |> put_change(:token, :crypto.strong_rand_bytes(@rand_size))
    |> assoc_constraint(:user)
  end
end
