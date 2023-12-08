defmodule ParkingLot.Document.Renavam do
  @moduledoc """
  Renavam (Registro Nacional de Veículos Automotores) document implementation.

  Validation based on the [validation-br](https://github.com/klawdyo/validation-br/blob/v.1.4.2/src/renavam.ts) JS library.
  """

  alias ParkingLot.{Digits, Document}

  @behaviour Document

  defstruct [:base, :check_digit]

  @impl true
  def new(digits) do
    {base, [check_digit]} = Enum.split(Digits.pad_leading(digits, 11), -1)

    if not Digits.monodigit?(base) and match?(^check_digit, check_digit(base)) do
      {:ok, struct(__MODULE__, base: base, check_digit: check_digit)}
    else
      {:error, %{reason: "invalid digits"}}
    end
  end

  @impl true
  def to_digits(%{base: base, check_digit: check_digit}) do
    Enum.concat(base, [check_digit])
  end

  @doc false
  def check_digit(base) do
    weights = Enum.concat(3..2, 9..2)

    weighted_sum = Document.weighted_sum(base, weights)
    mod11 = rem(weighted_sum * 10, 11)
    if mod11 >= 10, do: 0, else: mod11
  end

  @impl true
  def to_string(cnh) do
    digits = to_digits(cnh)
    Digits.to_string(digits)
  end

  defimpl String.Chars do
    defdelegate to_string(cnh), to: ParkingLot.Document.Renavam
  end
end
