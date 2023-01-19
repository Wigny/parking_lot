defmodule ParkingLot.Video do
  @moduledoc """
  Poller used for reading a video stream frames
  """

  use GenServer

  alias Evision.VideoCapture

  @default_stream "rtsp://zephyr.rtsp.stream/pattern?streamKey=6bfd0f20eef65aae930a9d43fd43962d"

  def start_link(stream \\ @default_stream) do
    video = VideoCapture.videoCapture(stream, apiPreference: Evision.cv_CAP_FFMPEG())
    GenServer.start_link(__MODULE__, video)
  end

  @impl true
  def init(video) do
    schedule()

    {:ok, video}
  end

  @impl true
  def handle_info(:read, video) do
    frame = VideoCapture.read(video)

    IO.puts(frame)

    schedule()

    {:noreply, video}
  end

  defp schedule do
    Process.send_after(self(), :read, 1000)
  end
end
