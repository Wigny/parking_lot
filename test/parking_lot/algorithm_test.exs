defmodule ParkingLot.AlgorithmTest do
  use ParkingLot.DataCase

  alias ParkingLot.Algorithm

  describe "majority_voting/1" do
    test "returns the most frequently predicted character at each position" do
      assert ~w"R S W 6 A 8 7" ==
               Algorithm.majority_voting([
                 ~w"R S W 6 A 8 7",
                 ~w"R S W 6 4 8 7",
                 ~w"R S W G A 8 7"
               ])
    end
  end
end
