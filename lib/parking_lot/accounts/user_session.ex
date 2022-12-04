defmodule ParkingLot.Accounts.UserSession do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @rand_size 32

  schema "user_sessions" do
    field :token, :binary
    belongs_to :user, ParkingLot.Accounts.User

    timestamps updated_at: false
  end

  def generation_changeset(session, attrs) do
    session
    |> cast(attrs, [:user_id])
    |> put_change(:token, :crypto.strong_rand_bytes(@rand_size))
    |> assoc_constraint(:user)
  end
end
