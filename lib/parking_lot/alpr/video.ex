defmodule ParkingLot.ALPR.Video do
  @moduledoc """
  Watchs a video stream
  """

  use GenServer

  alias Evision.VideoCapture
  alias ParkingLot.Cameras.Camera
  alias ParkingLot.RegistryHelper

  @max_fps 30

  defmodule State do
    @moduledoc false

    @type t :: %__MODULE__{video: Evision.VideoCapture.t() | nil, frame: Evision.Mat.t() | nil}
    defstruct video: nil, frame: nil
  end

  # Client

  def start_link(%Camera{type: type, uri: uri}) do
    name = RegistryHelper.name(__MODULE__, type)
    GenServer.start_link(__MODULE__, URI.to_string(uri), name: name)
  end

  def frame(%Camera{type: type}) do
    pid = RegistryHelper.pid(__MODULE__, type)
    GenServer.call(pid, :frame)
  end

  # Server

  @impl true
  def init(stream) do
    Process.flag(:trap_exit, true)

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

    Process.send_after(self(), :read, cycle(video))

    {:noreply, %State{state | frame: frame}}
  end

  defp cycle(video) do
    fps = min(round(video.fps), @max_fps)
    div(:timer.seconds(1), fps)
  end
end
