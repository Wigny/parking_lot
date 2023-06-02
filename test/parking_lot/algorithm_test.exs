defmodule ParkingLot.AlgorithmTest do
  use ParkingLot.DataCase

  alias ParkingLot.Algorithm

  describe "majority_voting/1" do
    test "returns the most frequently predicted character at each position" do
      assert "RSW6A87" == Algorithm.majority_voting(["RSW6A87", "RSW6487", "RSWGA87"])
    end
  end
end
