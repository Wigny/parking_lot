defmodule ParkingLotWeb.DriverLiveTest do
  use ParkingLotWeb.ConnCase

  import Phoenix.LiveViewTest
  import ParkingLot.CustomersFixtures

  @create_attrs valid_driver_attributes(%{name: "some name"})
  @update_attrs valid_driver_attributes(%{name: "some updated name", active: false})
  @invalid_attrs %{name: nil, cpf: nil, cnh: nil, email: nil, phone: nil}

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
      assert html =~ driver.name
    end

    test "saves new driver", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.driver_index_path(conn, :index))

      assert index_live |> element("a", "New Driver") |> render_click() =~
               "New Driver"

      assert_patch(index_live, Routes.driver_index_path(conn, :new))

      assert index_live
             |> form("#driver-form", driver: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#driver-form", driver: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.driver_index_path(conn, :index))

      assert html =~ "Driver created successfully"
      assert html =~ "some name"
    end

    test "updates driver in listing", %{conn: conn, driver: driver} do
      {:ok, index_live, _html} = live(conn, Routes.driver_index_path(conn, :index))

      assert index_live |> element("#driver-#{driver.id} a", "Edit") |> render_click() =~
               "Edit Driver"

      assert_patch(index_live, Routes.driver_index_path(conn, :edit, driver))

      assert index_live
             |> form("#driver-form", driver: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#driver-form", driver: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.driver_index_path(conn, :index))

      assert html =~ "Driver updated successfully"
      assert html =~ "some updated name"
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
      assert html =~ driver.name
    end

    test "updates driver within modal", %{conn: conn, driver: driver} do
      {:ok, show_live, _html} = live(conn, Routes.driver_show_path(conn, :show, driver))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Driver"

      assert_patch(show_live, Routes.driver_show_path(conn, :edit, driver))

      assert show_live
             |> form("#driver-form", driver: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#driver-form", driver: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.driver_show_path(conn, :show, driver))

      assert html =~ "Driver updated successfully"
      assert html =~ "some updated name"
    end
  end
end
