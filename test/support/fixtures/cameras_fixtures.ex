defmodule ParkingLot.CamerasFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ParkingLot.Cameras` context.
  """

  alias ParkingLot.Cameras

  def valid_camera_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      type: Enum.random(Ecto.Enum.values(Cameras.Camera, :type)),
      uri: %URI{
        scheme: "rtsp",
        userinfo: "admin:123456",
        host: "127.0.0.1",
        port: 554,
        path: "/example",
        query: URI.encode_query(%{id: System.unique_integer([:positive])})
      }
    })
  end

  def camera_fixture(attrs \\ %{}) do
    {:ok, camera} =
      attrs
      |> valid_camera_attributes()
      |> Cameras.create_camera()

    camera
  end
end
