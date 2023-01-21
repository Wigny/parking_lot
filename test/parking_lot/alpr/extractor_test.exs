defmodule ParkingLot.ALPR.ExtractorTest do
  use ParkingLot.DataCase

  alias ParkingLot.ALPR.Extractor
  import ParkingLot.CustomersFixtures

  describe "capture/1" do
    test "captures mercosul license plate in text" do
      license_plate = unique_vehicle_license_plate(:mercosul)

      assert license_plate == Extractor.capture("random text #{license_plate}")
    end

    test "captures legacy license plate in text" do
      license_plate = unique_vehicle_license_plate(:legacy)

      assert license_plate == Extractor.capture("random text #{license_plate}")
    end

    test "doesn't capture in a non license plate text" do
      text = "random text"

      refute Extractor.capture(text)
    end

    test "captures first license plate on list of checks" do
      mercosul_license_plate = unique_vehicle_license_plate(:mercosul)
      legacy_license_plate = unique_vehicle_license_plate(:legacy)

      capture = Extractor.capture([mercosul_license_plate, legacy_license_plate])

      assert mercosul_license_plate == capture
      refute legacy_license_plate == capture
    end
  end
end
