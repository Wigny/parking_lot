defmodule ParkingLot.CheckDigit do
  @moduledoc """
  Utils for validating the check digits,
  based on https://github.com/klawdyo/validation-br/tree/v.1.4.2
  """

  alias ParkingLot.CheckDigit.Digits

  @validations [
    cpf: %{
      length: 11,
      weights: [Enum.to_list(10..2), Enum.to_list(11..2)]
    },
    cnh: %{
      length: 11,
      weights: [Enum.to_list(2..10), Enum.concat(3..11, [2])]
    }
  ]

  for {type, %{length: length, weights: weights}} <- @validations do
    def valid?(value, unquote(type)) do
      digits = Digits.to_digits(value, length: unquote(length))

      if Digits.duplicated?(digits) or length(digits) > unquote(length) do
        false
      else
        Enum.all?(unquote(weights), fn weight ->
          {bias, [check_digit | _]} = apply_weights(digits, weight)
          calculated_check_digit = calculate_check_digit(bias)

          match?(^check_digit, calculated_check_digit)
        end)
      end
    end

    def generate(unquote(type)) do
      base = Digits.random(0..9, unquote(length) - length(unquote(weights)))

      unquote(weights)
      |> Enum.reduce(base, fn weight, digits ->
        {bias, _check_digits} = apply_weights(digits, weight)
        calculated_check_digit = calculate_check_digit(bias)

        Enum.concat(digits, [calculated_check_digit])
      end)
      |> Digits.to_string()
    end
  end

  defp apply_weights(digits, weight) do
    {base, rest} = Enum.split(digits, length(weight))
    bias = Enum.zip(base, weight)

    {bias, rest}
  end

  defp calculate_check_digit(bias) do
    sum = Enum.reduce(bias, 0, fn {digit, weight}, acc -> digit * weight + acc end)

    mod11 = rem(sum, 11)
    if mod11 in [0, 1], do: 0, else: 11 - mod11
  end
end
