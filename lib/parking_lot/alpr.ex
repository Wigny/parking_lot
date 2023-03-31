defmodule ParkingLot.ALPR do
  @moduledoc false

  use Supervisor

  alias ParkingLot.ALPR.{Recognizer, Video, Watcher}
  alias ParkingLot.Cameras

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    cameras = Cameras.list_cameras()

    children = [Recognizer]

    cameras
    |> Enum.reduce(children, &children_by_camera/2)
    |> Supervisor.init(strategy: :one_for_one)
  end

  defp children_by_camera(camera, children) do
    video = %{
      id: {Video, camera.id},
      start: {
        Video,
        :start_link,
        [
          %{id: camera.id, stream: URI.to_string(camera.uri)},
          [name: {:via, Registry, {ParkingLot.Registry, "video_#{camera.id}"}}]
        ]
      }
    }

    watcher = %{
      id: {Watcher, camera.id},
      start: {Watcher, :start_link, [%{id: camera.id}]}
    }

    [video, watcher | children]
  end
end
