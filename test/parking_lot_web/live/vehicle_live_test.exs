defmodule ParkingLotWeb.VehicleLiveTest do
  use ParkingLotWeb.ConnCase

  import Phoenix.LiveViewTest
  import ParkingLot.CustomersFixtures

  defp get_vehicle_attibutes(_) do
    create_attrs = valid_vehicle_attributes(%{active: true})
    update_attrs = valid_vehicle_attributes(%{active: false})

    invalid_attrs = %{
      license_plate: nil,
      type_id: nil,
      model_id: nil,
      color_id: nil,
      active: false
    }

    %{create_attrs: create_attrs, update_attrs: update_attrs, invalid_attrs: invalid_attrs}
  end

  defp create_vehicle(_) do
    vehicle = vehicle_fixture()
    %{vehicle: vehicle}
  end

  setup :register_and_log_in_user

  describe "Index" do
    setup [:create_vehicle, :get_vehicle_attibutes]

    test "lists all vehicles", %{conn: conn, vehicle: vehicle} do
      {:ok, _index_live, html} = live(conn, Routes.vehicle_index_path(conn, :index))

      assert html =~ "Listing Vehicles"
      assert html =~ vehicle.license_plate
    end

    test "saves new vehicle", %{
      conn: conn,
      create_attrs: create_attrs,
      invalid_attrs: invalid_attrs
    } do
      {:ok, index_live, _html} = live(conn, Routes.vehicle_index_path(conn, :index))

      assert index_live |> element("a", "New Vehicle") |> render_click() =~
               "New Vehicle"

      assert_patch(index_live, Routes.vehicle_index_path(conn, :new))

      assert index_live
             |> form("#vehicle-form", vehicle: invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#vehicle-form", vehicle: create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.vehicle_index_path(conn, :index))

      assert html =~ "Vehicle created successfully"
      assert html =~ create_attrs.license_plate
    end

    test "updates vehicle in listing", %{
      conn: conn,
      vehicle: vehicle,
      update_attrs: update_attrs,
      invalid_attrs: invalid_attrs
    } do
      {:ok, index_live, _html} = live(conn, Routes.vehicle_index_path(conn, :index))

      assert index_live |> element("#vehicle-#{vehicle.id} a", "Edit") |> render_click() =~
               "Edit Vehicle"

      assert_patch(index_live, Routes.vehicle_index_path(conn, :edit, vehicle))

      assert index_live
             |> form("#vehicle-form", vehicle: invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#vehicle-form", vehicle: update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.vehicle_index_path(conn, :index))

      assert html =~ "Vehicle updated successfully"
      assert html =~ update_attrs.license_plate
    end

    test "deletes vehicle in listing", %{conn: conn, vehicle: vehicle} do
      {:ok, index_live, _html} = live(conn, Routes.vehicle_index_path(conn, :index))

      assert index_live |> element("#vehicle-#{vehicle.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#vehicle-#{vehicle.id}")
    end
  end

  describe "Show" do
    setup [:create_vehicle, :get_vehicle_attibutes]

    test "displays vehicle", %{conn: conn, vehicle: vehicle} do
      {:ok, _show_live, html} = live(conn, Routes.vehicle_show_path(conn, :show, vehicle))

      assert html =~ "Show Vehicle"
      assert html =~ vehicle.license_plate
    end

    test "updates vehicle within modal", %{
      conn: conn,
      vehicle: vehicle,
      update_attrs: update_attrs,
      invalid_attrs: invalid_attrs
    } do
      {:ok, show_live, _html} = live(conn, Routes.vehicle_show_path(conn, :show, vehicle))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Vehicle"

      assert_patch(show_live, Routes.vehicle_show_path(conn, :edit, vehicle))

      assert show_live
             |> form("#vehicle-form", vehicle: invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#vehicle-form", vehicle: update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.vehicle_show_path(conn, :show, vehicle))

      assert html =~ "Vehicle updated successfully"
      assert html =~ update_attrs.license_plate
    end
  end
end
