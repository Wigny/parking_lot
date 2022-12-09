defmodule ParkingLotWeb.DriverLiveTest do
  use ParkingLotWeb.ConnCase

  import Phoenix.LiveViewTest
  import ParkingLot.CustomersFixtures

  @create_attrs valid_driver_attributes()
  @invalid_attrs %{@create_attrs | cpf: "invalid cpf"}

  defp create_driver(_) do
    driver = driver_fixture()
    %{driver: driver}
  end

  setup :register_and_log_in_user

  describe "Index" do
    setup [:create_driver]

    test "lists all drivers", %{conn: conn, driver: driver} do
      {:ok, _index_live, html} = live(conn, Routes.driver_index_path(conn, :index))

      assert html =~ "Listing Drivers"
      assert html =~ driver.cnh
    end

    test "saves new driver", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.driver_index_path(conn, :index))

      assert index_live |> element("a", "New Driver") |> render_click() =~
               "New Driver"

      assert_patch(index_live, Routes.driver_index_path(conn, :new))

      assert index_live
             |> form("#driver-form", driver: @invalid_attrs)
             |> render_change() =~ "has invalid check digit"

      {:ok, _, html} =
        index_live
        |> form("#driver-form", driver: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.driver_index_path(conn, :index))

      assert html =~ "Driver created successfully"
      assert html =~ @create_attrs.cnh
    end

    test "deletes driver in listing", %{conn: conn, driver: driver} do
      {:ok, index_live, _html} = live(conn, Routes.driver_index_path(conn, :index))

      assert index_live |> element("#driver-#{driver.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#driver-#{driver.id}")
    end
  end

  describe "Show" do
    setup [:create_driver]

    test "displays driver", %{conn: conn, driver: driver} do
      {:ok, _show_live, html} = live(conn, Routes.driver_show_path(conn, :show, driver))

      assert html =~ "Show Driver"
      assert html =~ driver.cnh
    end
  end
end
