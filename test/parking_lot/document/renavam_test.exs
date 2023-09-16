defmodule ParkingLot.Document.RenavamTest do
  use ExUnit.Case, async: true

  import ParkingLot.Digits
  alias ParkingLot.Document.Renavam

  @renavam %Renavam{base: ~d[0123456789], check_digit: 7}

  describe "renavam" do
    test "new/1 returns a document struct validating the digits" do
      assert {:ok, @renavam} = Renavam.new(~d[01234567897])
      assert {:error, %{reason: "invalid digits"}} = Renavam.new(~d[01234567898])
    end

    test "to_digits/1 returns the document digits" do
      assert ~d[01234567897] = Renavam.to_digits(@renavam)
    end

    test "to_string/1 returns the document string representation" do
      assert "01234567897" = Renavam.to_string(@renavam)
    end
  end
end
