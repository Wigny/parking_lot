defmodule ParkingLot.ALPR.Video do
  @moduledoc """
  Handles video streams
  """

  alias Evision.VideoCapture

  def start(stream) do
    VideoCapture.videoCapture(stream, apiPreference: Evision.cv_CAP_FFMPEG())
  end

  def frame(video) do
    VideoCapture.read(video)
  end

  def finish(video) do
    VideoCapture.release(video)
  end
end
