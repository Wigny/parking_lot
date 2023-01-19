defmodule ParkingLot.ALPR.Video do
  @moduledoc """
  Handles video streams
  """

  alias Evision.VideoCapture

  @default_stream "rtsp://zephyr.rtsp.stream/pattern?streamKey=6bfd0f20eef65aae930a9d43fd43962d"

  def start(stream \\ @default_stream) do
    VideoCapture.videoCapture(stream, apiPreference: Evision.cv_CAP_FFMPEG())
  end

  def frame(video) do
    VideoCapture.read(video)
  end

  def finish(video) do
    VideoCapture.release(video)
  end
end
