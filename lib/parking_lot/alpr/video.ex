defmodule ParkingLot.ALPR.Video do
  @moduledoc """
  Watchs a video stream
  """

  use GenServer

  alias Evision.VideoCapture
  alias ParkingLot.Cameras.Camera

  @max_fps 10

  defmodule State do
    @moduledoc false

    @type t :: %__MODULE__{
            camera: Camera.t(),
            video: Evision.VideoCapture.t() | nil,
            frame: Evision.Mat.t() | nil
          }
    defstruct camera: nil, video: nil, frame: nil
  end

  # Client

  def start_link(%Camera{id: id} = camera) do
    name = {:via, Registry, {ParkingLot.Registry, "video_#{id}"}}
    GenServer.start_link(__MODULE__, camera, name: name)
  end

  def frame(%Camera{id: id}) do
    [{pid, nil}] = Registry.lookup(ParkingLot.Registry, "video_#{id}")
    GenServer.call(pid, :frame)
  end

  # Server

  @impl true
  def init(camera) do
    Process.flag(:trap_exit, true)

    {:ok, %State{camera: camera}, {:continue, :start}}
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
  def handle_continue(:start, %State{camera: camera} = state) do
    stream = URI.to_string(camera.uri)
    video = VideoCapture.videoCapture(stream, apiPreference: Evision.cv_CAP_FFMPEG())

    send(self(), :read)

    {:noreply, %State{state | video: video}}
  end

  @impl true
  def handle_info(:read, %State{video: %{isOpened: false}} = state) do
    {:stop, "Video stream isn't opened", state}
  end

  def handle_info(:read, %State{camera: camera, video: video} = state) do
    frame = if mat = VideoCapture.read(video), do: mat

    Process.send_after(self(), :read, cycle(video))

    Phoenix.PubSub.broadcast(ParkingLot.PubSub, "video", {:frame, camera.id, frame})

    {:noreply, %State{state | frame: frame}}
  end

  defp cycle(video) do
    fps = min(round(video.fps), @max_fps)
    div(:timer.seconds(1), fps)
  end
end
