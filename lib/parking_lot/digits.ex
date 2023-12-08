defmodule ParkingLot.Digits do
  @moduledoc false

  @type t :: list(non_neg_integer)

  defmacro sigil_d({:<<>>, _, [value]}, []) do
    parse(value)
  end

  @doc """
  Parses a text or numerical representation of an digits sequence.

  ## Examples

      iex> ParkingLot.Digits.parse(123)
      [1, 2, 3]
      iex> ParkingLot.Digits.parse("123")
      [1, 2, 3]
      iex> ParkingLot.Digits.parse("12-3")
      [1, 2, 3]
  """
  @spec parse(value :: non_neg_integer | binary) :: t
  def parse(value) when is_integer(value) do
    Integer.digits(value)
  end

  def parse(value) when is_binary(value) do
    value
    |> String.replace(~r/\D/, "")
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
  Converts a digits sequence to a binary.

  ## Examples

      iex> ParkingLot.Digits.to_string([1, 2, 3])
      "123"
  """
  @spec to_string(digits :: t) :: binary
  def to_string(digits) do
    Enum.join(digits)
  end

  @doc """
  Checks whether a digits sequence is composed by a single repeated digit.

  ## Examples

      iex> ParkingLot.Digits.monodigit?([1, 1, 1])
      true
      iex> ParkingLot.Digits.monodigit?([1, 2, 3])
      false
  """
  @spec monodigit?(digits :: t) :: boolean
  def monodigit?(digits) do
    uniq = Enum.uniq(digits)

    length(uniq) == 1
  end

  @doc """
  Returns a new digits sequence padded with 0 as the leading filler.

  ## Examples

      iex> ParkingLot.Digits.pad_leading([1, 2, 3], 4)
      [0, 1, 2, 3]

      iex> ParkingLot.Digits.pad_leading([1, 2, 3], 1)
      [1, 2, 3]

      iex> ParkingLot.Digits.pad_leading([1], 5)
      [0, 0, 0, 0, 1]
  """
  @spec pad_leading(digits :: t, count :: non_neg_integer) :: t
  def pad_leading(digits, count) do
    digits_length = length(digits)

    if digits_length >= count do
      digits
    else
      Enum.concat(List.duplicate(0, count - digits_length), digits)
    end
  end
end
