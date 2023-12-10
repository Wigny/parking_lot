defmodule ParkingLot.ALPR.RecognizerTest do
  use ParkingLot.DataCase

  alias ParkingLot.ALPR.Recognizer

  test "detect_vehicle/1" do
    image = Evision.imread("test/support/files/neural-network-sample.jpg")
    assert {"car", "Taiwanese", ["5", "8", "1", "9", "V", "N"]} = Recognizer.infer(image)

    mercosur = Evision.imread("test/support/files/plate.jpg")

    # The current neural network model wasn't trained with `Mercosur` license plates
    # and so it recognizes them as `European` license plates.
    assert {"car", "European", ["R", "S", "W", "6", "A", "8", "7"]} = Recognizer.infer(mercosur)
  end
end
