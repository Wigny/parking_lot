defmodule ParkingLotWeb.VehicleDriverLiveTest do
  use ParkingLotWeb.ConnCase

  import Phoenix.LiveViewTest
  import ParkingLot.CustomersFixtures

  defp get_vehicle_driver_attibutes(_) do
    create_attrs = valid_vehicle_driver_attributes(%{active: true})
    update_attrs = valid_vehicle_driver_attributes(%{active: false})
    invalid_attrs = %{driver_id: nil, vehicle_id: nil, active: false}

    %{create_attrs: create_attrs, update_attrs: update_attrs, invalid_attrs: invalid_attrs}
  end

  defp create_vehicle_driver(_) do
    vehicle_driver = vehicle_driver_fixture()
    %{vehicle_driver: vehicle_driver}
  end

  setup :register_and_log_in_user

  describe "Index" do
    setup [:create_vehicle_driver, :get_vehicle_driver_attibutes]

    test "lists all vehicles_drivers", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.vehicle_driver_index_path(conn, :index))

      assert html =~ "Listing vehicles-drivers"
    end

    test "saves new vehicle_driver", %{
      conn: conn,
      invalid_attrs: invalid_attrs,
      create_attrs: create_attrs
    } do
      {:ok, index_live, _html} = live(conn, Routes.vehicle_driver_index_path(conn, :index))

      assert index_live |> element("a", "New vehicle-driver") |> render_click() =~
               "New vehicle-driver"

      assert_patch(index_live, Routes.vehicle_driver_index_path(conn, :new))

      assert index_live
             |> form("#vehicle_driver-form", vehicle_driver: invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#vehicle_driver-form", vehicle_driver: create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.vehicle_driver_index_path(conn, :index))

      assert html =~ "Vehicle driver created successfully"
    end

    test "updates vehicle_driver in listing", %{
      conn: conn,
      vehicle_driver: vehicle_driver,
      invalid_attrs: invalid_attrs,
      update_attrs: update_attrs
    } do
      {:ok, index_live, _html} = live(conn, Routes.vehicle_driver_index_path(conn, :index))

      assert index_live
             |> element("#vehicle_driver-#{vehicle_driver.id} a", "Edit")
             |> render_click() =~
               "Edit vehicle-driver"

      assert_patch(index_live, Routes.vehicle_driver_index_path(conn, :edit, vehicle_driver))

      assert index_live
             |> form("#vehicle_driver-form", vehicle_driver: invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#vehicle_driver-form", vehicle_driver: update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.vehicle_driver_index_path(conn, :index))

      assert html =~ "Vehicle driver updated successfully"
    end

    test "deletes vehicle_driver in listing", %{conn: conn, vehicle_driver: vehicle_driver} do
      {:ok, index_live, _html} = live(conn, Routes.vehicle_driver_index_path(conn, :index))

      assert index_live
             |> element("#vehicle_driver-#{vehicle_driver.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#vehicle_driver-#{vehicle_driver.id}")
    end
  end

  describe "Show" do
    setup [:create_vehicle_driver, :get_vehicle_driver_attibutes]

    test "displays vehicle_driver", %{conn: conn, vehicle_driver: vehicle_driver} do
      {:ok, _show_live, html} =
        live(conn, Routes.vehicle_driver_show_path(conn, :show, vehicle_driver))

      assert html =~ "Show vehicle-driver"
    end

    test "updates vehicle_driver within modal", %{
      conn: conn,
      vehicle_driver: vehicle_driver,
      invalid_attrs: invalid_attrs,
      update_attrs: update_attrs
    } do
      {:ok, show_live, _html} =
        live(conn, Routes.vehicle_driver_show_path(conn, :show, vehicle_driver))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit vehicle-driver"

      assert_patch(show_live, Routes.vehicle_driver_show_path(conn, :edit, vehicle_driver))

      assert show_live
             |> form("#vehicle_driver-form", vehicle_driver: invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#vehicle_driver-form", vehicle_driver: update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.vehicle_driver_show_path(conn, :show, vehicle_driver))

      assert html =~ "Vehicle driver updated successfully"
    end
  end
end
