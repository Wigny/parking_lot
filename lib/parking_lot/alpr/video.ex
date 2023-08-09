defmodule ParkingLot.ALPR.Video do
  @moduledoc """
  Watchs a video stream
  """

  use GenServer

  import Evision.Constant, only: [cv_CAP_FFMPEG: 0]

  require Logger
  alias Evision.VideoCapture

  @fps 60

  # Client

  def start_link(%{stream: stream}, opts \\ [name: __MODULE__]) do
    GenServer.start_link(__MODULE__, stream, opts)
  end

  def frame(server \\ __MODULE__) do
    GenServer.call(server, :frame, :infinity)
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
  def handle_call(:frame, _from, video) do
    {:reply, VideoCapture.retrieve(video), video}
  end

  @impl true
  def handle_info(:grab, %{isOpened: false} = video) do
    # waits before exiting the process to start a new one
    Process.sleep(:timer.minutes(1))

    {:stop, "Video stream isn't opened", video}
  end

  def handle_info(:grab, video) do
    Process.send_after(self(), :grab, floor(:timer.seconds(1) / @fps))

    VideoCapture.grab(video)

    {:noreply, video}
  end
end
