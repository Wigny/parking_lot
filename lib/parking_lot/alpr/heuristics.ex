defmodule ParkingLot.ALPR.Heuristics do
  @moduledoc """
  Groups functions used to fine-tune the license plate recognition by applying heuristics on the
  results.
  """

  @swap %{
    letters: %{?0 => ?O, ?1 => ?I, ?2 => ?Z, ?4 => ?A, ?5 => ?S, ?6 => ?G, ?7 => ?Z, ?8 => ?B},
    numbers: %{?A => ?4, ?B => ?8, ?D => ?0, ?G => 6, ?I => ?1, ?Q => ?0, ?S => ?5, ?Z => ?7}
  }

  defguardp is_letter_char(char) when char in ?A..?Z
  defguardp is_number_char(char) when char in ?0..?9

  @doc """
  Finds the most frequent element of a enumerable.

  ## Examples

      iex> ParkingLot.ALPR.Heuristics.majority_voting(["A", "A", "B"])
      "A"
  """
  def majority_voting(enumerable) do
    enumerable
    |> Enum.frequencies()
    |> Enum.max_by(fn {_elem, frequency} -> frequency end)
    |> then(fn {elem, _frequency} -> elem end)
  end

  @doc """
  Replaces all missrecognized characters in a license plate by it's most similar character
  based on the license plate layout.

  ## Examples

      iex> ParkingLot.ALPR.Heuristics.replace_characters(:legacy, "NDNI828")
      "NDN1828"

      iex> ParkingLot.ALPR.Heuristics.replace_characters(:mercosur, "RSW6487")
      "RSW6A87"
  """

  def replace_characters(type, <<char::utf8, tail::binary>>)
      when is_number_char(char) do
    char = if value = @swap.letters[char], do: <<value::utf8>>, else: ""
    replace_characters(type, <<char::binary, tail::binary>>)
  end

  def replace_characters(type, <<head::binary-size(1), char::utf8, tail::binary>>)
      when is_number_char(char) do
    char = if value = @swap.letters[char], do: <<value::utf8>>, else: ""
    replace_characters(type, <<head::binary, char::binary, tail::binary>>)
  end

  def replace_characters(type, <<head::binary-size(2), char::utf8, tail::binary>>)
      when is_number_char(char) do
    char = if value = @swap.letters[char], do: <<value::utf8>>, else: ""
    replace_characters(type, <<head::binary, char::binary, tail::binary>>)
  end

  def replace_characters(type, <<head::binary-size(3), char::utf8, tail::binary>>)
      when is_letter_char(char) do
    char = if value = @swap.numbers[char], do: <<value::utf8>>, else: ""
    replace_characters(type, <<head::binary, char::binary, tail::binary>>)
  end

  def replace_characters(:legacy, <<head::binary-size(4), char::utf8, tail::binary>>)
      when is_letter_char(char) do
    char = if value = @swap.numbers[char], do: <<value::utf8>>, else: ""
    replace_characters(:legacy, <<head::binary, char::binary, tail::binary>>)
  end

  def replace_characters(:mercosur, <<head::binary-size(4), char::utf8, tail::binary>>)
      when is_number_char(char) do
    char = if value = @swap.letters[char], do: <<value::utf8>>, else: ""
    replace_characters(:mercosur, <<head::binary, char::binary, tail::binary>>)
  end

  def replace_characters(type, <<head::binary-size(5), char::utf8, tail::binary>>)
      when is_letter_char(char) do
    char = if value = @swap.numbers[char], do: <<value::utf8>>, else: ""
    replace_characters(type, <<head::binary, char::binary, tail::binary>>)
  end

  def replace_characters(type, <<head::binary-size(6), char::utf8>>)
      when is_letter_char(char) do
    char = if value = @swap.numbers[char], do: <<value::utf8>>, else: ""
    replace_characters(type, <<head::binary, char::binary>>)
  end

  def replace_characters(_type, license_plate) do
    license_plate
  end
end
