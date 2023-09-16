defmodule ParkingLot.Document.CPFTest do
  use ExUnit.Case, async: true

  import ParkingLot.Digits
  alias ParkingLot.Document.CPF

  @cpf %CPF{base: ~d[123456789], check_digits: ~d[09]}

  describe "cpf" do
    test "new/1 returns a document struct validating the digits" do
      assert {:ok, @cpf} = CPF.new(~d[12345678909])
      assert {:error, %CPF.Error{reason: "invalid digits"}} = CPF.new(~d[12345678900])
    end

    test "to_digits/1 returns the document digits" do
      assert ~d[12345678909] = CPF.to_digits(@cpf)
    end

    test "to_string/1 returns the document string representation" do
      assert "123.456.789-09" = CPF.to_string(@cpf)
    end
  end
end
