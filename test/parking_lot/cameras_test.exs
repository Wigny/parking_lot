defmodule ParkingLot.CamerasTest do
  use ParkingLot.DataCase

  alias ParkingLot.Cameras

  describe "cameras" do
    alias ParkingLot.Cameras.Camera

    import ParkingLot.CamerasFixtures

    @invalid_attrs %{type: nil, uri: nil}

    test "list_cameras/0 returns all cameras" do
      camera = camera_fixture()
      assert Cameras.list_cameras() == [camera]
    end

    test "get_camera!/1 returns the camera with given id" do
      camera = camera_fixture()
      assert Cameras.get_camera!(camera.id) == camera
    end

    test "create_camera/1 with valid data creates a camera" do
      valid_attrs = %{type: :internal, uri: "some uri"}

      assert {:ok, %Camera{} = camera} = Cameras.create_camera(valid_attrs)
      assert camera.type == :internal
      assert camera.uri == "some uri"
    end

    test "create_camera/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cameras.create_camera(@invalid_attrs)
    end

    test "update_camera/2 with valid data updates the camera" do
      camera = camera_fixture()
      update_attrs = %{type: :external, uri: "some updated uri"}

      assert {:ok, %Camera{} = camera} = Cameras.update_camera(camera, update_attrs)
      assert camera.type == :external
      assert camera.uri == "some updated uri"
    end

    test "update_camera/2 with invalid data returns error changeset" do
      camera = camera_fixture()
      assert {:error, %Ecto.Changeset{}} = Cameras.update_camera(camera, @invalid_attrs)
      assert camera == Cameras.get_camera!(camera.id)
    end

    test "delete_camera/1 deletes the camera" do
      camera = camera_fixture()
      assert {:ok, %Camera{}} = Cameras.delete_camera(camera)
      assert_raise Ecto.NoResultsError, fn -> Cameras.get_camera!(camera.id) end
    end

    test "change_camera/1 returns a camera changeset" do
      camera = camera_fixture()
      assert %Ecto.Changeset{} = Cameras.change_camera(camera)
    end
  end
end
