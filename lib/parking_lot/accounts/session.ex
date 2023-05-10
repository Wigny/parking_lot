defmodule ParkingLot.Accounts.Session do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @rand_size 32
  @timestamps_opts [type: :utc_datetime]

  schema "sessions" do
    field :token, :binary
    belongs_to :user, ParkingLot.Accounts.User

    timestamps updated_at: false
  end

  def changeset(session, attrs) do
    session
    |> cast(attrs, [:user_id])
    |> put_change(:token, :crypto.strong_rand_bytes(@rand_size))
    |> assoc_constraint(:user)
  end
end
