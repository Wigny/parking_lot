defmodule ParkingLot.ALPR.VideoTest do
  use ParkingLot.DataCase

  alias ParkingLot.ALPR.Video

  @camera %ParkingLot.Cameras.Camera{
    uri: %URI{
      scheme: "file",
      path: Path.join([__DIR__, "..", "..", "support", "files", "video_frame.mp4"])
    },
    type: :internal
  }

  describe "frame/1" do
    setup _ do
      start_supervised!({Video, @camera})

      :ok
    end

    test "returns the last stream frame" do
      assert nil == Video.frame(@camera)
      assert %Evision.Mat{shape: {1080, 1920, 3}} = Video.frame(@camera)
    end
  end
end
