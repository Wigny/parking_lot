defmodule ParkingLot.ALPR.Video do
  @moduledoc """
  Watchs a video stream
  """
  use GenServer

  import Evision.Constant, only: [cv_CAP_FFMPEG: 0]

  alias Evision.VideoCapture

  @max_fps 60

  def start_link(opts) do
    GenServer.start_link(__MODULE__, Map.new(opts), name: __MODULE__)
  end

  def init(attrs) do
    Process.flag(:trap_exit, true)

    {:ok, attrs, {:continue, :start}}
  end

  def handle_continue(:start, %{stream: stream}) do
    video = VideoCapture.videoCapture(stream, apiPreference: cv_CAP_FFMPEG())

    send(self(), :read)

    {:noreply, video}
  end

  def handle_info(:read, %{isOpened: false} = video) do
    {:stop, "Video stream isn't opened", video}
  end

  def handle_info(:read, video) do
    frame = if mat = VideoCapture.read(video), do: mat

    Process.send_after(self(), :read, cycle(video))

    Phoenix.PubSub.broadcast(ParkingLot.PubSub, "video", {:frame, frame})

    {:noreply, video}
  end

  defp cycle(video) do
    fps = min(round(video.fps), @max_fps)
    div(:timer.seconds(1), fps)
  end
end
