defmodule ParkingLot.ALPR.VideoTest do
  use ParkingLot.DataCase

  alias ParkingLot.ALPR.Video

  setup _ do
    start_supervised!({Video, %{stream: "file:test/support/files/plate.mp4"}})

    :ok
  end

  test "frame/1 returns the lastest stream frame" do
    Process.sleep(1000)

    assert %Evision.Mat{shape: {1080, 1920, 3}} = Video.frame()
  end
end
