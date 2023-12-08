defmodule ParkingLot.ALPR.HeuristicsTest do
  use ParkingLot.DataCase

  alias ParkingLot.ALPR.Heuristics

  doctest Heuristics

  test "replace_characters/2" do
    assert "BRA2O20" = Heuristics.replace_characters(:mercosur, "BRA2020")
    assert "ABC1234" = Heuristics.replace_characters(:legacy, "ABCI234")
    assert "QOZ1774" = Heuristics.replace_characters(:legacy, "Q0ZI774")
  end
end
