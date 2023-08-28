defmodule ParkingLot.Document.CPF do
  alias ParkingLot.Digits

  @behaviour ParkingLot.Document

  defstruct [:base, :check_digits]

  @impl true
  def new(digits) do
    {base, check_digits} = Enum.split(Digits.pad_leading(digits, 11), -2)
    struct(__MODULE__, base: base, check_digits: check_digits)
  end

  @impl true
  def to_digits(%{base: base, check_digits: check_digits}) do
    Enum.concat([base, check_digits])
  end

  # https://github.com/klawdyo/validation-br/blob/v.1.4.2/src/cpf.ts
  @impl true
  def valid?(%{base: base, check_digits: check_digits}) do
    check_digit_1 = Digits.check_digit(base, 10..2)
    check_digit_2 = Digits.check_digit(base ++ [check_digit_1], 11..2)

    match?(^check_digits, [check_digit_1, check_digit_2])
  end

  defimpl String.Chars do
    alias ParkingLot.Digits
    alias ParkingLot.Document.CPF

    def to_string(cpf) do
      digits = CPF.to_digits(cpf)
      Digits.to_string(digits)
    end
  end

  defimpl Phoenix.HTML.Safe do
    def to_iodata(cpf) do
      String.replace(to_string(cpf), ~r/(\d{3})(\d{3})(\d{3})(\d{2})/, ~S"\1.\2.\3-\4")
    end
  end
end
