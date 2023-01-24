defmodule ParkingLot.ALPR.RecognizerTest do
  use ParkingLot.DataCase

  alias ParkingLot.ALPR.Recognizer

  @license_plate Path.join([__DIR__ | ~w[.. .. support files license_plate.png]])

  describe "infer/1" do
    setup do
      %{image: Evision.imread(@license_plate)}
    end

    test "recognizes texts in image", %{image: image} do
      assert "QRM7E33" in Recognizer.infer(image)
    end
  end
end
