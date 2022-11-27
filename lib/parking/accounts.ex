defmodule Parking.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query

  alias Parking.Repo
  alias Parking.Accounts.{User, UserSession}

  @session_validity_in_days 60

  def fetch_or_create_user(attrs) do
    if user = get_user_by_email(attrs.email) do
      {:ok, user}
    else
      register_user(attrs)
    end
  end

  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def get_user_by_session_token(token) do
    User
    |> join(:left, [user], assoc(user, :sessions))
    |> where([user, session], session.token == ^token)
    |> where([user, token], token.inserted_at > ago(@session_validity_in_days, "day"))
    |> select([user, token], user)
    |> Repo.one()
  end

  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def generate_user_session_token(user) do
    session =
      %UserSession{}
      |> UserSession.generation_changeset(%{user_id: user.id})
      |> Repo.insert!()

    session.token
  end

  def delete_session_token(token) do
    UserSession
    |> where(token: ^token)
    |> Repo.delete_all()

    :ok
  end
end
