defmodule ParkingLot.ALPR.Video do
  @moduledoc """
  Watchs a video stream
  """

  use GenServer

  alias Evision.VideoCapture
  alias ParkingLot.Cameras.Camera

  @max_fps 30

  defmodule State do
    @moduledoc false

    @type t :: %__MODULE__{video: Evision.VideoCapture.t() | nil, frame: Evision.Mat.t() | nil}
    defstruct video: nil, frame: nil
  end

  # Client

  def start_link(%Camera{type: type, uri: uri}) do
    name = {:via, Registry, {ParkingLot.Registry, type}}
    GenServer.start_link(__MODULE__, URI.to_string(uri), name: name)
  end

  def frame(pid) do
    GenServer.call(pid, :frame)
  end

  # Server

  @impl true
  def init(stream) do
    {:ok, stream, {:continue, :start}}
  end

  @impl true
  def terminate(_reason, %State{video: video} = state) do
    %State{state | video: VideoCapture.release(video)}
  end

  @impl true
  def handle_call(:frame, _from, %State{frame: frame} = state) do
    {:reply, frame, state}
  end

  @impl true
  def handle_continue(:start, stream) do
    video = VideoCapture.videoCapture(stream, apiPreference: Evision.cv_CAP_FFMPEG())

    send(self(), :read)

    {:noreply, %State{video: video}}
  end

  @impl true
  def handle_info(:read, %State{video: %{isOpened: false}} = state) do
    {:stop, :normal, state}
  end

  def handle_info(:read, %State{video: video} = state) do
    frame = if mat = VideoCapture.read(video), do: mat

    delay = div(:timer.seconds(1), min(video.fps, @max_fps))
    Process.send_after(self(), :read, delay)

    {:noreply, %State{state | frame: frame}}
  end
end
