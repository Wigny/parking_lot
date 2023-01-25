defmodule ParkingLot.ALPR.Video do
  @moduledoc """
  Watchs a video stream
  """

  use GenServer

  alias Evision.VideoCapture
  alias ParkingLot.Cameras.Camera

  @max_fps 30

  # Client

  def start_link(%Camera{type: type, uri: uri}) do
    GenServer.start_link(__MODULE__, URI.to_string(uri), name: type)
  end

  def frame(pid) do
    GenServer.call(pid, :frame)
  end

  # Server (callbacks)

  @impl true
  def init(stream) do
    video = VideoCapture.videoCapture(stream, apiPreference: Evision.cv_CAP_FFMPEG())

    {:ok, %{video: video}, {:continue, :read}}
  end

  @impl true
  def terminate(_reason, %{video: video} = state) do
    VideoCapture.release(video)

    state
  end

  @impl true
  def handle_call(:frame, _from, %{frame: frame} = state), do: {:reply, frame, state}

  @impl true
  def handle_continue(:read, state), do: read(state)

  @impl true
  def handle_info(:read, state), do: read(state)

  defp read(%{video: %{isOpened: false}} = state) do
    {:stop, :normal, state}
  end

  defp read(%{video: video} = state) do
    frame = if mat = VideoCapture.read(video), do: mat, else: nil

    delay = div(:timer.seconds(1), min(video.fps, @max_fps))
    schedule_read(delay)

    {:noreply, Map.put(state, :frame, frame)}
  end

  defp schedule_read(delay) do
    Process.send_after(self(), :read, delay)
  end
end
