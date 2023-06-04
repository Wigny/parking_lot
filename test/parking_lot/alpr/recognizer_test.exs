defmodule ParkingLot.ALPR.Text.RecognizerTest do
  use ParkingLot.DataCase

  alias ParkingLot.ALPR.Recognizer

  @license_plate "test/support/files/plate.png"

  describe "infer/1" do
    setup do
      %{image: Evision.imread(@license_plate)}
    end

    test "recognizes plate digits in image", %{image: image} do
      assert ~w"R S W 6 A 8 7" == Recognizer.infer(image)
    end
  end
end
