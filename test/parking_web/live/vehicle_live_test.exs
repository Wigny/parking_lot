defmodule ParkingWeb.VehicleLiveTest do
  use ParkingWeb.ConnCase

  import Phoenix.LiveViewTest
  import ParkingLot.CustomersFixtures

  @create_attrs valid_vehicle_attributes()
  @invalid_attrs %{license_plate: "invalid plate"}

  defp create_vehicle(_) do
    vehicle = vehicle_fixture()
    %{vehicle: vehicle}
  end

  setup :register_and_log_in_user

  describe "Index" do
    setup [:create_vehicle]

    test "lists all vehicles", %{conn: conn, vehicle: vehicle} do
      {:ok, _index_live, html} = live(conn, Routes.vehicle_index_path(conn, :index))

      assert html =~ "Listing Vehicles"
      assert html =~ vehicle.license_plate
    end

    test "saves new vehicle", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.vehicle_index_path(conn, :index))

      assert index_live
             |> element("a", "New Vehicle")
             |> render_click() =~ "New Vehicle"

      assert_patch(index_live, Routes.vehicle_index_path(conn, :new))

      assert index_live
             |> form("#vehicle-form", vehicle: @invalid_attrs)
             |> render_change() =~ "has invalid format"

      {:ok, _, html} =
        index_live
        |> form("#vehicle-form", vehicle: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.vehicle_index_path(conn, :index))

      assert html =~ "Vehicle created successfully"
      assert html =~ @create_attrs.license_plate
    end

    test "deletes vehicle in listing", %{conn: conn, vehicle: vehicle} do
      {:ok, index_live, _html} = live(conn, Routes.vehicle_index_path(conn, :index))

      assert index_live |> element("#vehicle-#{vehicle.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#vehicle-#{vehicle.id}")
    end
  end

  describe "Show" do
    setup [:create_vehicle]

    test "displays vehicle", %{conn: conn, vehicle: vehicle} do
      {:ok, _show_live, html} = live(conn, Routes.vehicle_show_path(conn, :show, vehicle))

      assert html =~ "Show Vehicle"
      assert html =~ vehicle.license_plate
    end
  end
end
