defmodule ParkingLotWeb.PageController do
  use ParkingLotWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
