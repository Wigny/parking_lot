defmodule ParkingLot.ALPR.VideoTest do
  use ParkingLot.DataCase

  alias ParkingLot.ALPR.Video

  describe "frame/1" do
    setup _ do
      start_supervised!({Video, %{stream: "file:test/support/files/plate.mp4"}})

      :ok
    end

    test "returns the lastest stream frame" do
      refute Video.frame()
      assert %Evision.Mat{shape: {1080, 1920, 3}} = Video.frame()
    end
  end
end
