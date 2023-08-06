defmodule ParkingLot.ALPR do
  @moduledoc false

  use DynamicSupervisor

  alias ParkingLot.ALPR.{Video, Watcher}

  def start_link(args) do
    DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def start_children(camera) do
    with {:ok, _pid} <- start_video(camera) do
      start_watcher(camera)
    end
  end

  def terminate_children(camera) do
    with {:ok, nil} <- terminate_child("video_#{camera.id}") do
      terminate_child("watcher_#{camera.id}")
    end
  end

  defp start_watcher(camera) do
    name = {:via, Registry, {ParkingLot.Registry, "watcher_#{camera.id}"}}

    child = %{
      id: {Watcher, camera.id},
      start: {Watcher, :start_link, [%{camera: camera}, [name: name]]}
    }

    DynamicSupervisor.start_child(__MODULE__, child)
  end

  defp start_video(camera) do
    name = {:via, Registry, {ParkingLot.Registry, "video_#{camera.id}"}}

    child = %{
      id: {Video, camera.id},
      start: {Video, :start_link, [%{stream: URI.to_string(camera.uri)}, [name: name]]}
    }

    DynamicSupervisor.start_child(__MODULE__, child)
  end

  defp terminate_child(name) do
    with [{child, nil}] <- Registry.lookup(ParkingLot.Registry, name) do
      :ok = DynamicSupervisor.terminate_child(__MODULE__, child)
    end

    {:ok, nil}
  end

  @impl true
  def init(_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
