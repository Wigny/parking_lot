defmodule ParkingLotWeb.ParkingLiveTest do
  use ParkingLotWeb.ConnCase

  import Phoenix.LiveViewTest
  import ParkingLot.ParkingsFixtures

  defp create_parking(_) do
    parking = parking_fixture()
    %{parking: parking}
  end

  setup :register_and_log_in_user

  describe "Index" do
    setup [:create_parking]

    test "lists all parkings", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.parking_index_path(conn, :index))

      assert html =~ "Listing Parkings"
    end
  end

  describe "Show" do
    setup [:create_parking]

    test "displays parking", %{conn: conn, parking: parking} do
      {:ok, _show_live, html} = live(conn, Routes.parking_show_path(conn, :show, parking))

      assert html =~ "Show Parking"
    end
  end
end
