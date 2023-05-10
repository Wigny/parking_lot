defmodule ParkingLot.Digits do
  @moduledoc false

  def to_digits(value, opts \\ [])

  def to_digits(value, opts) when is_integer(value) do
    digits = Integer.digits(value)
    to_digits(digits, opts)
  end

  def to_digits(value, opts) when is_binary(value) do
    case Integer.parse(value) do
      {digits, _binary} -> to_digits(digits, Keyword.put_new(opts, :length, String.length(value)))
      :error -> []
    end
  end

  def to_digits(value, length: length) when is_list(value) do
    count = max(length - length(value), 0)
    pad_leading(value, count, 0)
  end

  def to_string(digits) do
    Enum.join(digits)
  end

  def random(length, base \\ 0..9) do
    generator = fn -> Enum.random(base) end

    generator
    |> Stream.repeatedly()
    |> Enum.take(length)
  end

  def duplicated?(digits) do
    uniq = Enum.uniq(digits)

    length(uniq) == 1
  end

  defp pad_leading(enum, 0, _padding) do
    enum
  end

  defp pad_leading(enum, count, padding) do
    pad_leading([padding | enum], count - 1, padding)
  end
end
