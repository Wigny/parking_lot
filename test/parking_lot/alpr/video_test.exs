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

  describe "start_link/1" do
    test "expects a `Camera` struct" do
      assert {:ok, pid} = Video.start_link(@camera)

      GenServer.stop(pid)
    end
  end

  describe "frame/1" do
    setup _ do
      %{video: start_supervised!({Video, @camera})}
    end

    test "returns the last stream frame", %{video: video} do
      assert %Evision.Mat{shape: {1080, 1920, 3}} = Video.frame(video)
    end
  end
end
