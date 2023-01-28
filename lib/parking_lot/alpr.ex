defmodule ParkingLot.ALPR do
  @moduledoc false

  use Supervisor

  alias ParkingLot.ALPR.{Image, Text, Video}
  alias ParkingLot.Cameras

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    # children =     [
    #   Text.Recognizer,
    #   Supervisor.child_spec({Video, camera1}, id: :video_1),
    #   Supervisor.child_spec({Video, camera2}, id: :video_2),
    #   Supervisor.child_spec({Image, camera1}, id: :image_1),
    #   Supervisor.child_spec({Image, camera2}, id: :image_2)
    # ]

    Cameras.list_cameras()
    |> Enum.reduce([Text.Recognizer], fn camera, children ->
      video = Supervisor.child_spec({Video, camera}, id: "video_#{camera.id}")
      image = Supervisor.child_spec({Image, camera}, id: "image_#{camera.id}")

      [video, image | children]
    end)
    |> Supervisor.init(strategy: :one_for_one)
  end
end
