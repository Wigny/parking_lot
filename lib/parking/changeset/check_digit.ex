defmodule Parking.Changeset.CheckDigit do
  @moduledoc false

  @check_digit_validations [
    cpf: %{
      length: 11,
      weights: [Enum.to_list(10..2), Enum.to_list(11..2)]
    },
    cnh: %{
      length: 11,
      weights: [Enum.to_list(2..10), Enum.concat(3..11, [2])]
    }
  ]

  def valid?(digits, type) when is_binary(digits) do
    case Integer.parse(digits) do
      {digits, ""} -> valid?(digits, type)
      :error -> false
    end
  end

  def valid?(digits, type) when is_integer(digits) do
    digits
    |> Integer.digits()
    |> valid?(type)
  end

  for {type, %{length: length, weights: weights}} <- @check_digit_validations do
    def valid?(digits, unquote(type)) when is_list(digits) do
      if dup?(digits) or length(digits) > 11 do
        false
      else
        digits = pad_leading(digits, unquote(length) - length(digits), 0)

        Enum.all?(unquote(weights), fn weight ->
          {check_digit, digits_weights} = combine(digits, weight)

          match?(^check_digit, calculate_check_digit(digits_weights))
        end)
      end
    end

    def predict(digits, unquote(type)) do
      Enum.reduce(unquote(weights), [], fn weight, check_digits ->
        {_check_digit, digits_weights} = combine(digits ++ check_digits, weight)

        check_digit = calculate_check_digit(digits_weights)
        check_digits ++ [check_digit]
      end)
    end
  end

  defp dup?(digits) do
    uniq = Enum.uniq(digits)

    length(uniq) == 1
  end

  defp combine(digits, weight) do
    {base, check_digits} = Enum.split(digits, length(weight))

    {List.first(check_digits), Enum.zip(base, weight)}
  end

  defp calculate_check_digit(digits_weights) do
    sum = Enum.reduce(digits_weights, 0, fn {digit, weight}, acc -> digit * weight + acc end)

    mod11 = rem(sum, 11)
    if mod11 in [0, 1], do: 0, else: 11 - mod11
  end

  defp pad_leading(enum, 0, _padding) do
    enum
  end

  defp pad_leading(enum, count, padding) do
    pad_leading([padding | enum], count - 1, padding)
  end
end
