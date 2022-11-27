defmodule Parking.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Parking.Accounts` context.
  """

  alias Parking.Accounts

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
