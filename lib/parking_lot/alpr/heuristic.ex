defmodule ParkingLot.ALPR.Heuristic do
  @moduledoc false

  @swap %{
    letters: %{
      ?0 => ?O,
      ?1 => ?I,
      ?2 => ?Z,
      ?3 => ?B,
      ?4 => ?A,
      ?5 => ?S,
      ?6 => ?G,
      ?7 => ?Z,
      ?8 => ?B
    },
    numbers: %{
      ?A => ?4,
      ?B => ?8,
      ?D => ?0,
      ?I => ?1,
      ?J => ?1,
      ?Q => ?0,
      ?S => ?5,
      ?Z => ?7
    }
  }

  defguardp is_letter_char(char) when char in ?A..?Z
  defguardp is_number_char(char) when char in ?0..?9

  def replace(<<c1::utf8, c2::utf8, c3::utf8, c4::utf8, c5::utf8, c6::utf8, c7::utf8>> = plate)
      when is_letter_char(c1) and
             is_letter_char(c2) and
             is_letter_char(c3) and
             is_number_char(c4) and
             (is_number_char(c5) or is_letter_char(c5)) and
             is_number_char(c6) and
             is_number_char(c7) do
    plate
  end

  def replace(<<char::utf8, tail::binary>>) when is_number_char(char) do
    replace(<<@swap.letters[char], tail::binary>>)
  end

  def replace(<<head::binary-size(1), char::utf8, tail::binary>>) when is_number_char(char) do
    replace(<<head::binary, @swap.letters[char], tail::binary>>)
  end

  def replace(<<head::binary-size(2), char::utf8, tail::binary>>) when is_number_char(char) do
    replace(<<head::binary, @swap.letters[char], tail::binary>>)
  end

  def replace(<<head::binary-size(3), char::utf8, tail::binary>>) when is_letter_char(char) do
    replace(<<head::binary, @swap.numbers[char], tail::binary>>)
  end

  def replace(<<head::binary-size(5), char::utf8, tail::binary>>) when is_letter_char(char) do
    replace(<<head::binary, @swap.numbers[char], tail::binary>>)
  end

  def replace(<<head::binary-size(6), char::utf8>>) when is_letter_char(char) do
    replace(<<head::binary, @swap.numbers[char]>>)
  end
end
