defmodule ParkingLotWeb.CameraLiveTest do
  use ParkingLotWeb.ConnCase

  import Phoenix.LiveViewTest
  import ParkingLot.CamerasFixtures

  @create_attrs %{type: :external, uri: "some uri"}
  @update_attrs %{type: :external, uri: "some updated uri"}
  @invalid_attrs %{type: nil, uri: nil}

  defp create_camera(_) do
    camera = camera_fixture(%{type: :internal})
    %{camera: camera}
  end

  setup :register_and_log_in_user

  describe "Index" do
    setup [:create_camera]

    test "lists all cameras", %{conn: conn, camera: camera} do
      {:ok, _index_live, html} = live(conn, Routes.camera_index_path(conn, :index))

      assert html =~ "Listing Cameras"
      assert html =~ camera.uri
    end

    test "saves new camera", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.camera_index_path(conn, :index))

      assert index_live |> element("a", "New Camera") |> render_click() =~
               "New Camera"

      assert_patch(index_live, Routes.camera_index_path(conn, :new))

      assert index_live
             |> form("#camera-form", camera: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#camera-form", camera: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.camera_index_path(conn, :index))

      assert html =~ "Camera created successfully"
      assert html =~ "some uri"
    end

    test "updates camera in listing", %{conn: conn, camera: camera} do
      {:ok, index_live, _html} = live(conn, Routes.camera_index_path(conn, :index))

      assert index_live |> element("#camera-#{camera.id} a", "Edit") |> render_click() =~
               "Edit Camera"

      assert_patch(index_live, Routes.camera_index_path(conn, :edit, camera))

      assert index_live
             |> form("#camera-form", camera: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#camera-form", camera: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.camera_index_path(conn, :index))

      assert html =~ "Camera updated successfully"
      assert html =~ "some updated uri"
    end

    test "deletes camera in listing", %{conn: conn, camera: camera} do
      {:ok, index_live, _html} = live(conn, Routes.camera_index_path(conn, :index))

      assert index_live |> element("#camera-#{camera.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#camera-#{camera.id}")
    end
  end

  describe "Show" do
    setup [:create_camera]

    test "displays camera", %{conn: conn, camera: camera} do
      {:ok, _show_live, html} = live(conn, Routes.camera_show_path(conn, :show, camera))

      assert html =~ "Show Camera"
      assert html =~ camera.uri
    end

    test "updates camera within modal", %{conn: conn, camera: camera} do
      {:ok, show_live, _html} = live(conn, Routes.camera_show_path(conn, :show, camera))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Camera"

      assert_patch(show_live, Routes.camera_show_path(conn, :edit, camera))

      assert show_live
             |> form("#camera-form", camera: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#camera-form", camera: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.camera_show_path(conn, :show, camera))

      assert html =~ "Camera updated successfully"
      assert html =~ "some updated uri"
    end
  end
end
