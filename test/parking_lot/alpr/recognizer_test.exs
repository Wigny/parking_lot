defmodule ParkingLot.ALPR.Text.RecognizerTest do
  use ParkingLot.DataCase

  alias ParkingLot.ALPR.Recognizer

  describe "infer/1" do
    test "recognizes mercosur license plate digits in image" do
      image = Evision.imread("test/support/files/plate.png")

      assert ["R", "S", "W", "6", "A", "8", "7"] == Recognizer.infer(image)
    end
  end
end
