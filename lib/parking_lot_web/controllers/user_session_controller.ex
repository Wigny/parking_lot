defmodule ParkingLotWeb.UserSessionController do
  use ParkingLotWeb, :controller

  import ParkingLotWeb.UserAuth, only: [log_out_user: 1]

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> log_out_user()
  end
end
