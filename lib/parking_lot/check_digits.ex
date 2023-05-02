defmodule ParkingLot.CheckDigits do
  @moduledoc """
  Utils for validating the check digits,
  based on https://github.com/klawdyo/validation-br/tree/v.1.4.2
  """

  def valid?(digits, weights) do
    Enum.all?(weights, fn weight ->
      {base, [check_digit | _check_digits]} = Enum.split(digits, length(weight))

      match?(^check_digit, check_digit(base, weight))
    end)
  end

  def generate(seed, weights) do
    Enum.reduce(weights, seed, fn weight, digits ->
      {base, _check_digits} = Enum.split(digits, length(weight))

      Enum.concat(base, [check_digit(base, weight)])
    end)
  end

  defp check_digit(digits, weights) do
    digits
    |> Enum.zip(weights)
    |> Enum.map(&Tuple.product/1)
    |> Enum.sum()
    |> mod11()
  end

  defp mod11(value) do
    rem = rem(value, 11)

    if rem < 2, do: 0, else: 11 - rem
  end
end
