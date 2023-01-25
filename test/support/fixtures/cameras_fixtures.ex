defmodule ParkingLot.CamerasFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ParkingLot.Cameras` context.
  """

  @doc """
  Generate a unique camera type.
  """
  def unique_camera_type do
    Enum.random(Ecto.Enum.values(ParkingLot.Cameras.Camera, :type))
  end

  @doc """
  Generate a unique camera uri.
  """
  def unique_camera_uri, do: "some uri#{System.unique_integer([:positive])}"

  @doc """
  Generate a camera.
  """
  def camera_fixture(attrs \\ %{}) do
    {:ok, camera} =
      attrs
      |> Enum.into(%{
        type: unique_camera_type(),
        uri: unique_camera_uri()
      })
      |> ParkingLot.Cameras.create_camera()

    camera
  end
end
