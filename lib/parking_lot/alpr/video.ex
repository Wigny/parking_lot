defmodule ParkingLot.ALPR.Video do
  @moduledoc """
  Watchs a video stream
  """

  use GenServer

  import Evision.Constant, only: [cv_CAP_FFMPEG: 0]

  alias Evision.VideoCapture

  # Client

  def start_link(%{stream: stream}, opts \\ [name: __MODULE__]) do
    GenServer.start_link(__MODULE__, stream, opts)
  end

  def frame(server \\ __MODULE__) do
    GenServer.call(server, :frame)
  end

  # Server

  @impl true
  def init(stream) do
    Process.flag(:trap_exit, true)

    {:ok, stream, {:continue, :start}}
  end

  @impl true
  def handle_continue(:start, stream) do
    video = VideoCapture.videoCapture(stream, apiPreference: cv_CAP_FFMPEG())

    send(self(), :grab)

    {:noreply, video}
  end

  @impl true
  def terminate(_reason, video) do
    VideoCapture.release(video)
  end

  @impl true
  def handle_call(:frame, _from, %{isOpened: false} = video) do
    {:stop, "Video stream isn't opened", video}
  end

  @impl true
  def handle_call(:frame, _from, video) do
    frame = VideoCapture.retrieve(video)

    {:reply, frame, video}
  end

  @impl true
  def handle_info(:grab, video) do
    true = VideoCapture.grab(video)

    Process.send_after(self(), :grab, floor(:timer.seconds(1) / video.fps))

    {:noreply, video}
  end
end
