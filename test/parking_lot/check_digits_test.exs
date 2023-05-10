defmodule ParkingLot.CheckDigitsTest do
  use ParkingLot.DataCase

  alias ParkingLot.{CheckDigits, Digits}

  @valid_digits %{
    cpf: Digits.to_digits("15886489070"),
    cnh: Digits.to_digits("69044271146")
  }

  @invalid_digits %{
    cpf: Digits.to_digits("15886489071"),
    cnh: Digits.to_digits("69044271147")
  }

  @weights %{
    cpf: [Enum.to_list(10..2), Enum.to_list(11..2)],
    cnh: [Enum.to_list(2..10), Enum.concat(3..11, [2])]
  }

  describe "valid?/2" do
    test "asserts digits with an valid check digits" do
      assert CheckDigits.valid?(@valid_digits.cpf, @weights.cpf)
      assert CheckDigits.valid?(@valid_digits.cnh, @weights.cnh)
    end

    test "refutes digits with an invalid check digit" do
      refute CheckDigits.valid?(@invalid_digits.cpf, @weights.cpf)
      refute CheckDigits.valid?(@invalid_digits.cnh, @weights.cnh)
    end
  end

  describe "generate/2" do
    test "generates a valid digit with it's check digits" do
      seed = Digits.random(9)

      assert cpf = CheckDigits.generate(seed, @weights.cpf)
      assert CheckDigits.valid?(cpf, @weights.cpf)

      assert cnh = CheckDigits.generate(seed, @weights.cnh)
      assert CheckDigits.valid?(cnh, @weights.cnh)
    end
  end
end
