defmodule ParkingLot.Document.CNH do
  alias ParkingLot.Digits

  @behaviour ParkingLot.Document

  defstruct [:base, :check_digits]

  @weights [
    2..10,
    Enum.concat(3..11, [2])
  ]

  @impl true
  def new(digits) do
    {base, check_digits} = Enum.split(Digits.pad_leading(digits, 11), -2)
    struct(__MODULE__, base: base, check_digits: check_digits)
  end

  @impl true
  def to_digits(%{base: base, check_digits: check_digits}) do
    Enum.concat([base, check_digits])
  end

  # https://github.com/klawdyo/validation-br/blob/v.1.4.2/src/cnh.ts
  @impl true
  def valid?(%{base: base, check_digits: check_digits}) do
    check_digit_1 = Digits.check_digit(base, 2..10)
    check_digit_2 = Digits.check_digit(Enum.concat(base, [digit1]), Enum.concat(3..11, [2]))

    match?(^check_digits, [check_digit_1, check_digit_2])
  end

  defimpl String.Chars do
    alias ParkingLot.Digits
    alias ParkingLot.Document.CNH

    def to_string(cnh) do
      digits = CNH.to_digits(cnh)
      Digits.to_string(digits)
    end
  end

  defimpl Phoenix.HTML.Safe do
    def to_iodata(cnh), do: to_string(cnh)
  end
end
