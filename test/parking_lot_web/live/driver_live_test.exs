defmodule ParkingLotWeb.DriverLiveTest do
  use ParkingLotWeb.ConnCase

  import Phoenix.LiveViewTest
  import ParkingLot.CustomersFixtures

  @create_attrs %{
    active: true,
    cnh: "some cnh",
    cpf: "some cpf",
    email: "some email",
    name: "some name",
    phone: "some phone"
  }
  @update_attrs %{
    active: false,
    cnh: "some updated cnh",
    cpf: "some updated cpf",
    email: "some updated email",
    name: "some updated name",
    phone: "some updated phone"
  }
  @invalid_attrs %{active: false, cnh: nil, cpf: nil, email: nil, name: nil, phone: nil}

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
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#driver-form", driver: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.driver_index_path(conn, :index))

      assert html =~ "Driver created successfully"
      assert html =~ "some cnh"
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
      assert html =~ "some updated cnh"
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
      assert html =~ "some updated cnh"
    end
  end
end
