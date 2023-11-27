defmodule ParkingLotWeb.UserSessionController do
  use ParkingLotWeb, :controller

  import ParkingLotWeb.UserAuth
  alias ParkingLot.Accounts

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user(email: email, password: password) do
      conn
      |> put_flash(:info, gettext("Welcome back!"))
      |> log_in_user(user, user_params)
    else
      conn
      |> put_flash(:error, gettext("Invalid email or password"))
      |> put_flash(:email, String.slice(email, 0, 160))
      |> redirect(to: ~p"/users/log_in")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, gettext("Logged out successfully."))
    |> log_out_user()
  end
end
