defmodule ParkingLot.ALPR.VideoTest do
  use ParkingLot.DataCase

  alias Evision.VideoCapture
  alias ParkingLot.ALPR.Video

  @video_frame Path.join([__DIR__, "..", "..", "support", "files", "video_frame.mp4"])

  test "takes a frame from a video" do
    assert %VideoCapture{isOpened: true} = video = Video.start(@video_frame)
    assert %Evision.Mat{shape: {1080, 1920, 3}} = Video.frame(video)
    assert %VideoCapture{isOpened: false} = Video.finish(video)
  end
end
