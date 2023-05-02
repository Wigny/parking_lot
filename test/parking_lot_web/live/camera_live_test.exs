defmodule ParkingLotWeb.CameraLiveTest do
  use ParkingLotWeb.ConnCase

  import Phoenix.LiveViewTest
  import ParkingLot.CamerasFixtures

  @create_attrs valid_camera_attributes(%{type: :external})
  @update_attrs valid_camera_attributes(%{type: :external})
  @invalid_attrs %{type: nil, uri: nil}

  defp create_camera(_) do
    camera = camera_fixture(%{type: :internal})
    %{camera: camera}
  end

  setup :register_and_log_in_user

  describe "Index" do
    setup [:create_camera]

    test "lists all cameras", %{conn: conn, camera: camera} do
      {:ok, _index_live, html} = live(conn, ~p"/cameras")

      assert html =~ "Listing Cameras"
      assert html =~ URI.to_string(camera.uri)
    end

    test "saves new camera", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/cameras")

      assert index_live |> element("a", "New Camera") |> render_click() =~
               "New Camera"

      assert_patch(index_live, ~p"/cameras/new")

      assert index_live
             |> form("#camera-form", camera: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#camera-form", camera: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/cameras")

      html = render(index_live)
      assert html =~ "Camera created successfully"
      assert html =~ URI.to_string(@create_attrs.uri)
    end

    test "updates camera in listing", %{conn: conn, camera: camera} do
      {:ok, index_live, _html} = live(conn, ~p"/cameras")

      assert index_live |> element("#cameras-#{camera.id} a", "Edit") |> render_click() =~
               "Edit Camera"

      assert_patch(index_live, ~p"/cameras/#{camera}/edit")

      assert index_live
             |> form("#camera-form", camera: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#camera-form", camera: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/cameras")

      html = render(index_live)
      assert html =~ "Camera updated successfully"
      assert html =~ URI.to_string(@update_attrs.uri)
    end

    test "deletes camera in listing", %{conn: conn, camera: camera} do
      {:ok, index_live, _html} = live(conn, ~p"/cameras")

      assert index_live |> element("#cameras-#{camera.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#cameras-#{camera.id}")
    end
  end

  describe "Show" do
    setup [:create_camera]

    test "displays camera", %{conn: conn, camera: camera} do
      {:ok, _show_live, html} = live(conn, ~p"/cameras/#{camera}")

      assert html =~ "Show Camera"
      assert html =~ URI.to_string(camera.uri)
    end

    test "updates camera within modal", %{conn: conn, camera: camera} do
      {:ok, show_live, _html} = live(conn, ~p"/cameras/#{camera}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Camera"

      assert_patch(show_live, ~p"/cameras/#{camera}/show/edit")

      assert show_live
             |> form("#camera-form", camera: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#camera-form", camera: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/cameras/#{camera}")

      html = render(show_live)
      assert html =~ "Camera updated successfully"
      assert html =~ URI.to_string(@update_attrs.uri)
    end
  end
end
