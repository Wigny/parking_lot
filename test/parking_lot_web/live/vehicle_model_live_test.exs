defmodule ParkingLotWeb.VehicleModelLiveTest do
  use ParkingLotWeb.ConnCase

  import Phoenix.LiveViewTest
  import ParkingLot.VehiclesFixtures

  defp get_model_attibutes(_) do
    create_attrs = valid_model_attributes(%{name: "some name"})
    update_attrs = valid_model_attributes(%{name: "some updated name"})
    invalid_attrs = %{brand_id: nil, name: nil}

    %{attrs: %{create: create_attrs, update: update_attrs, invalid: invalid_attrs}}
  end

  defp create_model(_) do
    model = model_fixture()
    %{model: model}
  end

  setup :register_and_log_in_user

  describe "Index" do
    setup [:create_model, :get_model_attibutes]

    test "lists all vehicle_models", %{conn: conn, model: model} do
      {:ok, _index_live, html} = live(conn, ~p"/vehicle/models")

      assert html =~ "Listing models"
      assert html =~ model.name
    end

    test "saves new model", %{conn: conn, attrs: attrs} do
      {:ok, index_live, _html} = live(conn, ~p"/vehicle/models")

      assert index_live
             |> element("a", "New model")
             |> render_click() =~ "New model"

      assert_patch(index_live, ~p"/vehicle/models/new")

      assert index_live
             |> form("#model-form", model: attrs.invalid)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#model-form", model: attrs.create)
             |> render_submit()

      assert_patch(index_live, ~p"/vehicle/models")

      html = render(index_live)
      assert html =~ "Model created successfully"
      assert html =~ "some name"
    end

    test "updates model in listing", %{conn: conn, model: model, attrs: attrs} do
      {:ok, index_live, _html} = live(conn, ~p"/vehicle/models")

      assert index_live
             |> element("#vehicle_models-#{model.id} a", "Edit")
             |> render_click() =~ "Edit model"

      assert_patch(index_live, ~p"/vehicle/models/#{model}/edit")

      assert index_live
             |> form("#model-form", model: attrs.invalid)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#model-form", model: attrs.update)
             |> render_submit()

      assert_patch(index_live, ~p"/vehicle/models")

      html = render(index_live)
      assert html =~ "Model updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes model in listing", %{conn: conn, model: model} do
      {:ok, index_live, _html} = live(conn, ~p"/vehicle/models")

      assert index_live |> element("#vehicle_models-#{model.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#vehicle_models-#{model.id}")
    end
  end

  describe "Show" do
    setup [:create_model, :get_model_attibutes]

    test "displays model", %{conn: conn, model: model} do
      {:ok, _show_live, html} = live(conn, ~p"/vehicle/models/#{model}")

      assert html =~ "Show model"
      assert html =~ model.name
    end

    test "updates model within modal", %{conn: conn, model: model, attrs: attrs} do
      {:ok, show_live, _html} = live(conn, ~p"/vehicle/models/#{model}")

      assert show_live
             |> element("a", "Edit")
             |> render_click() =~ "Edit model"

      assert_patch(show_live, ~p"/vehicle/models/#{model}/show/edit")

      assert show_live
             |> form("#model-form", model: attrs.invalid)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#model-form", model: attrs.update)
             |> render_submit()

      assert_patch(show_live, ~p"/vehicle/models/#{model}")

      html = render(show_live)
      assert html =~ "Model updated successfully"
      assert html =~ "some updated name"
    end
  end
end
