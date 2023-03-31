defmodule ParkingLot.ALPR.Video do
  @moduledoc """
  Watchs a video stream
  """

  use GenServer

  import Evision.Constant, only: [cv_CAP_FFMPEG: 0]

  alias Evision.VideoCapture

  @max_fps 60

  # Client

  def start_link(%{id: id, stream: stream}, opts \\ []) do
    GenServer.start_link(__MODULE__, %{id: id, stream: stream}, opts)
  end

  def frame(server) do
    GenServer.call(server, :frame)
  end

  # Server

  @impl true
  def init(attrs) do
    Process.flag(:trap_exit, true)

    {:ok, attrs, {:continue, :start}}
  end

  @impl true
  def handle_continue(:start, %{id: id, stream: stream}) do
    video = VideoCapture.videoCapture(stream, apiPreference: cv_CAP_FFMPEG())

    send(self(), :read)

    {:noreply, %{id: id, video: video, frame: nil}}
  end

  @impl true
  def terminate(_reason, %{video: video} = state) do
    %{state | video: VideoCapture.release(video)}
  end

  @impl true
  def handle_info(:read, %{video: %{isOpened: false}} = state) do
    {:stop, "Video stream isn't opened", state}
  end

  def handle_info(:read, %{video: video} = state) do
    frame = if mat = VideoCapture.read(video), do: mat

    Process.send_after(self(), :read, cycle(video))

    # Phoenix.PubSub.broadcast(ParkingLot.PubSub, "alpr", {:frame, state.id, frame})

    {:noreply, %{state | frame: frame}}
  end

  @impl true
  def handle_call(:frame, _from, %{frame: frame} = state) do
    {:reply, frame, state}
  end

  defp cycle(video) do
    fps = min(round(video.fps), @max_fps)
    div(:timer.seconds(1), fps)
  end
end
