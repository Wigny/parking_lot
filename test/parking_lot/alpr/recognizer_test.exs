defmodule ParkingLot.ALPR.Text.RecognizerTest do
  use ParkingLot.DataCase

  alias ParkingLot.ALPR.Recognizer

  @license_plate "test/support/files/plate.png"

  describe "infer/1" do
    setup do
      %{image: Evision.imread(@license_plate)}
    end

    test "recognizes texts in image", %{image: image} do
      plate = Nx.tensor([[552, 653], [585, 529], [1090, 571], [1058, 695]], type: :s32)

      assert {"RRSW6487", plate} in Recognizer.infer(image)
    end
  end
end
