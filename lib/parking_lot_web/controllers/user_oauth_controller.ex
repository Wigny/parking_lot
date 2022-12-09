defmodule ParkingLotWeb.UserOAuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """

  use ParkingLotWeb, :controller

  import ParkingLotWeb.UserAuth,
    only: [
      log_in_user: 2,
      log_out_user: 1,
      require_authenticated_user: 1
    ]

  alias ParkingLot.Accounts

  plug Ueberauth

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> log_out_user()
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, %{"provider" => "google"}) do
    user_params = %{email: auth.info.email}

    case Accounts.fetch_or_create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> log_in_user(user)

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> require_authenticated_user()
    end
  end
end
