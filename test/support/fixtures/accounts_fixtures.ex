defmodule ParkingLot.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ParkingLot.Accounts` context.
  """

  alias ParkingLot.Accounts

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password(),
      admin: true
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Accounts.create_user()

    user
  end

  def session_fixture(attrs \\ %{}) do
    attrs
    |> Map.new()
    |> Map.put_new_lazy(:user_id, fn ->
      user = user_fixture()
      user.id
    end)
    |> Accounts.create_session!()
  end
end
