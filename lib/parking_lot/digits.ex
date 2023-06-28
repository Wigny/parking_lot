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

  def parse(value) when is_integer(value) do
    Integer.digits(value)
  end

  def parse(value) when is_binary(value) do
    value
    |> String.replace(~r/\D/, "")
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def to_string(digits) do
    Enum.join(digits)
  end

  @doc """
  Returns random digits given the desired length.

  ### Example

      # Although not necessary, let's seed the random algorithm
      iex> :rand.seed(:exsss, {1, 2, 3})
      iex> ParkingLot.Digits.random(3)
      [6, 0, 4]
      iex> ParkingLot.Digits.random(3, [3, 4, 5, 6])
      [5, 5, 4]
  """
  def random(length, elements \\ 0..9) do
    generator = fn -> Enum.random(elements) end

    generator
    |> Stream.repeatedly()
    |> Enum.take(length)
  end

  def duplicated?(digits) do
    uniq = Enum.uniq(digits)

    length(uniq) == 1
  end

  @doc """
  Returns a new digits sequence padded with 0 as the leading filler.

  ### Example

      iex> ParkingLot.Digits.pad_leading([1, 2, 3], 4)
      [0, 1, 2, 3]

      iex> ParkingLot.Digits.pad_leading([1, 2, 3], 1)
      [1, 2, 3]

      iex> ParkingLot.Digits.pad_leading([1], 5)
      [0, 0, 0, 0, 1]
  """

  def pad_leading(digits, count) do
    digits_length = length(digits)

    if digits_length >= count do
      digits
    else
      Enum.concat(List.duplicate(0, count - digits_length), digits)
    end
  end
end
