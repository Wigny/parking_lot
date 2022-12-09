defmodule ParkingLot.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ParkingLot.Accounts` context.
  """

  alias ParkingLot.Accounts

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: "user#{System.unique_integer()}@example.com"
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Accounts.register_user()

    user
  end
end
