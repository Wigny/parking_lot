defmodule ParkingLot.Cameras do
  @moduledoc """
  The Cameras context.
  """

  import Ecto.Query, warn: false
  alias ParkingLot.Repo

  alias ParkingLot.Cameras.Camera

  def list_cameras() do
    Repo.all(where(Camera, type: :internal))
  end

  def get_camera!(id), do: Repo.get!(Camera, id)

  def create_camera(attrs \\ %{}) do
    %Camera{}
    |> Camera.changeset(attrs)
    |> Repo.insert()
  end

  def update_camera(%Camera{} = camera, attrs) do
    camera
    |> Camera.changeset(attrs)
    |> Repo.update()
  end

  def delete_camera(%Camera{} = camera) do
    Repo.delete(camera)
  end

  def change_camera(%Camera{} = camera, attrs \\ %{}) do
    Camera.changeset(camera, attrs)
  end
end
