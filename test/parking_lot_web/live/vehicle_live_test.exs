defmodule ParkingLotWeb.VehicleLiveTest do
  use ParkingLotWeb.ConnCase

  import Phoenix.LiveViewTest
  import ParkingLot.CustomersFixtures

  defp get_vehicle_attibutes(_) do
    create_attrs = valid_vehicle_attributes(%{active: true})
    update_attrs = valid_vehicle_attributes(%{active: false})

    invalid_attrs = %{
      license_plate: nil,
      model_id: nil,
      color_id: nil,
      active: false
    }

    %{attrs: %{create: create_attrs, update: update_attrs, invalid: invalid_attrs}}
  end

  defp create_vehicle(_) do
    vehicle = vehicle_fixture()
    %{vehicle: vehicle}
  end

  setup :register_and_log_in_user

  describe "Index" do
    setup [:create_vehicle, :get_vehicle_attibutes]

    test "lists all vehicles", %{conn: conn, vehicle: vehicle} do
      {:ok, _index_live, html} = live(conn, ~p"/vehicles")

      assert html =~ "Listing vehicles"
      assert html =~ vehicle.license_plate
    end

    test "saves new vehicle", %{conn: conn, attrs: attrs} do
      {:ok, index_live, _html} = live(conn, ~p"/vehicles")

      assert index_live
             |> element("a", "New vehicle")
             |> render_click() =~ "New vehicle"

      assert_patch(index_live, ~p"/vehicles/new")

      assert index_live
             |> form("#vehicle-form", vehicle: attrs.invalid)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#vehicle-form", vehicle: attrs.create)
             |> render_submit()

      assert_patch(index_live, ~p"/vehicles")

      html = render(index_live)
      assert html =~ "Vehicle created successfully"
      assert html =~ attrs.create.license_plate
    end

    test "updates vehicle in listing", %{conn: conn, vehicle: vehicle, attrs: attrs} do
      {:ok, index_live, _html} = live(conn, ~p"/vehicles")

      assert index_live
             |> element("#vehicles-#{vehicle.id} a", "Edit")
             |> render_click() =~ "Edit vehicle"

      assert_patch(index_live, ~p"/vehicles/#{vehicle}/edit")

      assert index_live
             |> form("#vehicle-form", vehicle: attrs.invalid)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#vehicle-form", vehicle: attrs.update)
             |> render_submit()

      assert_patch(index_live, ~p"/vehicles")

      html = render(index_live)
      assert html =~ "Vehicle updated successfully"
      assert html =~ attrs.update.license_plate
    end

    test "deletes vehicle in listing", %{conn: conn, vehicle: vehicle} do
      {:ok, index_live, _html} = live(conn, ~p"/vehicles")

      assert index_live |> element("#vehicles-#{vehicle.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#vehicles-#{vehicle.id}")
    end
  end

  describe "Show" do
    setup [:create_vehicle, :get_vehicle_attibutes]

    test "displays vehicle", %{conn: conn, vehicle: vehicle} do
      {:ok, _show_live, html} = live(conn, ~p"/vehicles/#{vehicle}")

      assert html =~ "Show vehicle"
      assert html =~ vehicle.license_plate
    end

    test "updates vehicle within modal", %{conn: conn, vehicle: vehicle, attrs: attrs} do
      {:ok, show_live, _html} = live(conn, ~p"/vehicles/#{vehicle}")

      assert show_live
             |> element("a", "Edit")
             |> render_click() =~ "Edit vehicle"

      assert_patch(show_live, ~p"/vehicles/#{vehicle}/show/edit")

      assert show_live
             |> form("#vehicle-form", vehicle: attrs.invalid)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#vehicle-form", vehicle: attrs.update)
             |> render_submit()

      assert_patch(show_live, ~p"/vehicles/#{vehicle}")

      html = render(show_live)
      assert html =~ "Vehicle updated successfully"
      assert html =~ attrs.update.license_plate
    end
  end
end
