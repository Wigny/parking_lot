defmodule ParkingLot.AccountsTest do
  use ParkingLot.DataCase

  import ParkingLot.AccountsFixtures

  alias ParkingLot.Accounts
  alias ParkingLot.Accounts.{Session, User}

  describe "get_user/1" do
    setup do
      user = user_fixture()
      %{token: token} = session_fixture(%{user_id: user.id})

      %{user: user, token: token}
    end

    test "does not return the user if the email does not exist" do
      refute Accounts.get_user(email: "unknown@example.com")
    end

    test "returns the user if the email exists", %{user: %{id: id, email: email}} do
      assert %User{id: ^id} = Accounts.get_user(email: email)
    end

    test "returns user by token", %{user: user, token: token} do
      assert session_user = Accounts.get_user(session: [token: token])
      assert session_user.id == user.id
    end

    test "does not return user for invalid token" do
      refute Accounts.get_user(session: [token: "oops"])
    end

    test "does not return user for expired token", %{token: token} do
      {1, nil} = Repo.update_all(Session, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      refute Accounts.get_user(session: [token: token])
    end
  end

  describe "create_user/1" do
    test "requires email to be set" do
      {:error, changeset} = Accounts.create_user(%{})

      errors = errors_on(changeset)
      assert "can't be blank" in errors.email
    end

    test "validates email when given" do
      {:error, changeset} = Accounts.create_user(%{email: "not valid"})

      errors = errors_on(changeset)
      assert "must have the @ sign and no spaces" in errors.email
    end

    test "validates maximum values for email for security" do
      too_long = String.duplicate("db", 100)
      {:error, changeset} = Accounts.create_user(%{email: too_long})

      errors = errors_on(changeset)
      assert "should be at most 160 character(s)" in errors.email
    end

    test "validates email uniqueness" do
      %{email: email} = user_fixture()
      {:error, changeset} = Accounts.create_user(%{email: email})

      errors = errors_on(changeset)
      assert "has already been taken" in errors.email

      # Now try with the upper cased email too, to check that email case is ignored.
      {:error, changeset} = Accounts.create_user(%{email: String.upcase(email)})

      errors = errors_on(changeset)
      assert "has already been taken" in errors.email
    end
  end

  describe "create_session!/1" do
    setup do
      %{user: user_fixture()}
    end

    test "generates a token", %{user: user} do
      %{token: token} = Accounts.create_session!(%{user_id: user.id})
      assert user_token = Repo.get_by(Session, token: token)

      # Creating the same token for another user should fail
      assert_raise Ecto.ConstraintError, fn ->
        another_user = user_fixture()

        Repo.insert!(%Session{token: user_token.token, user_id: another_user.id})
      end
    end
  end

  describe "delete_sessions/1" do
    test "deletes the token" do
      user = user_fixture()
      %{token: token} = session_fixture(%{user_id: user.id})

      assert Accounts.delete_sessions(token: token) == :ok

      refute Accounts.get_user(session: [token: token])
    end
  end
end
