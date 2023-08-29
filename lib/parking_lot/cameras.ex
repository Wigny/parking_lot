defmodule ParkingLot.Cameras do
  @moduledoc """
  The Cameras context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias ParkingLot.ALPR
  alias ParkingLot.Repo

  alias ParkingLot.Cameras.Camera

  def list_cameras do
    Camera
    |> order_by(asc: :type)
    |> Repo.all()
  end

  def list_cameras(attrs) when is_list(attrs) do
    Camera
    |> where(^attrs)
    |> order_by(asc: :type)
    |> Repo.all()
  end

  def get_camera!(id), do: Repo.get!(Camera, id)

  def create_camera(attrs \\ %{}) do
    Multi.new()
    |> Multi.insert(:camera, Camera.changeset(%Camera{}, attrs))
    |> Multi.run(:alpr_watcher, fn _repo, %{camera: camera} ->
      if camera.active, do: ALPR.start_children(camera), else: {:ok, nil}
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{camera: camera}} -> {:ok, camera}
      {:error, :camera, changeset, _changes} -> {:error, changeset}
    end
  end

  def update_camera(%Camera{} = camera, attrs) do
    Multi.new()
    |> Multi.update(:camera, Camera.changeset(camera, attrs))
    |> Multi.run({:stop, :alpr_watcher}, fn _repo, _changes ->
      if camera.active, do: ALPR.terminate_children(camera), else: {:ok, nil}
    end)
    |> Multi.run({:start, :alpr_watcher}, fn _repo, %{camera: camera} ->
      if camera.active, do: ALPR.start_children(camera), else: {:ok, nil}
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{camera: camera}} -> {:ok, camera}
      {:error, :camera, changeset, _changes} -> {:error, changeset}
    end
  end

  def delete_camera(%Camera{} = camera) do
    Multi.new()
    |> Multi.delete(:camera, camera)
    |> Multi.run(:alpr_watcher, fn _repo, %{camera: camera} ->
      if camera.active, do: ALPR.terminate_children(camera), else: {:ok, nil}
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{camera: camera}} -> {:ok, camera}
      {:error, :camera, changeset, _changes} -> {:error, changeset}
    end
  end

  def change_camera(%Camera{} = camera, attrs \\ %{}) do
    Camera.changeset(camera, attrs)
  end
end
