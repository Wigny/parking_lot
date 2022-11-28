defmodule Parking.Changeset.CheckDigitTest do
  use Parking.DataCase

  alias Parking.Changeset.CheckDigit

  @valid_cpf "15886489070"
  @invalid_cpf "15886489071"

  @valid_cnh "69044271146"
  @invalid_cnh "69044271147"

  describe "valid?/2" do
    test "asserts digits with an valid check digits" do
      assert CheckDigit.valid?(@valid_cpf, :cpf)
      assert CheckDigit.valid?(@valid_cnh, :cnh)
    end

    test "validates digits which is a list of integers" do
      cpf = Integer.digits(String.to_integer(@valid_cpf))
      assert CheckDigit.valid?(cpf, :cpf)

      cnh = Integer.digits(String.to_integer(@valid_cnh))
      assert CheckDigit.valid?(cnh, :cnh)
    end

    test "refutes digits with only duplicated digits" do
      digits = List.duplicate(5, 11)

      refute CheckDigit.valid?(digits, :cpf)
      refute CheckDigit.valid?(digits, :cnh)
    end

    test "refutes CPF digits with length bigger then 11" do
      refute CheckDigit.valid?(@valid_cpf <> @valid_cpf, :cpf)
    end

    test "refutes CNH digits with length bigger then 11" do
      refute CheckDigit.valid?(@valid_cnh <> @valid_cnh, :cnh)
    end

    test "refutes digits with an invalid check digits" do
      refute CheckDigit.valid?(@invalid_cpf, :cpf)
      refute CheckDigit.valid?(@invalid_cnh, :cnh)
    end
  end

  describe "predict/2" do
    test "predicts digits' check digits" do
      cpf = Integer.digits(String.to_integer(@valid_cpf))
      {cpf_base, cpf_check_digits} = Enum.split(cpf, 9)

      assert cpf_check_digits == CheckDigit.predict(cpf_base, :cpf)

      cnh = Integer.digits(String.to_integer(@valid_cnh))
      {cnh_base, cnh_check_digits} = Enum.split(cnh, 9)

      assert cnh_check_digits == CheckDigit.predict(cnh_base, :cnh)
    end
  end
end
