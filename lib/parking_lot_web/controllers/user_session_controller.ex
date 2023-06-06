defmodule ParkingLotWeb.UserSessionController do
  use ParkingLotWeb, :controller

  import ParkingLotWeb.UserAuth
  alias ParkingLot.Accounts

  plug Ueberauth

  def create(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: ~p"/")
  end

  def create(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case Accounts.get_or_create_user(email: auth.info.email) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> log_in_user(user)

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: ~p"/")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> log_out_user()
  end
end
