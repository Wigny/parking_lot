defmodule ParkingLot.Document.CNHTest do
  use ExUnit.Case, async: true

  import ParkingLot.Digits
  alias ParkingLot.Document.CNH

  @cpf %CNH{base: ~d[123456789], check_digits: ~d[00]}

  describe "cpf" do
    test "new/1 returns a document struct validating the digits" do
      assert {:ok, @cpf} = CNH.new(~d[12345678900])
      assert {:error, %CNH.Error{reason: "invalid digits"}} = CNH.new(~d[12345678901])
    end

    test "to_digits/1 returns the document digits" do
      assert ~d[12345678900] = CNH.to_digits(@cpf)
    end

    test "to_string/1 returns the document string representation" do
      assert "12345678900" = CNH.to_string(@cpf)
    end
  end
end
