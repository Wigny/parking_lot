defmodule ParkingLot.Document.CNH do
  @moduledoc """
  CNH (Carteira Nacional de Habilitação) document implementation.

  Validation based on the [validation-br](https://github.com/klawdyo/validation-br/blob/v.1.4.2/src/cnh.ts) JS library.
  """

  alias ParkingLot.{Digits, Document}

  @behaviour Document

  defstruct [:base, :check_digits]

  defmodule Error do
    defexception [:reason]

    def new(fields), do: struct!(__MODULE__, fields)

    def message(%{reason: "invalid digits"}), do: "The CNH is invalid"
  end

  @impl true
  def new(digits) do
    {base, check_digits} = Enum.split(Digits.pad_leading(digits, 11), -2)

    if not Digits.monodigit?(base) and match?(^check_digits, check_digits(base)) do
      {:ok, struct(__MODULE__, base: base, check_digits: check_digits)}
    else
      {:error, Error.new(reason: "invalid digits")}
    end
  end

  @impl true
  def to_digits(%{base: base, check_digits: check_digits}) do
    Enum.concat([base, check_digits])
  end

  @impl true
  def to_string(cnh) do
    digits = to_digits(cnh)
    Digits.to_string(digits)
  end

  @doc false
  def check_digits(base) do
    [2..10, Enum.concat(3..11, [2])]
    |> Stream.transform(base, fn weigths, digits ->
      weighted_sum = Document.weighted_sum(digits, weigths)
      mod11 = rem(weighted_sum, 11)
      digit = if mod11 < 2, do: 0, else: 11 - mod11

      {[digit], digits ++ [digit]}
    end)
    |> Enum.to_list()
  end

  defimpl String.Chars do
    defdelegate to_string(cnh), to: ParkingLot.Document.CNH
  end

  defimpl Inspect do
    def inspect(cnh, _opts) do
      Inspect.Algebra.concat(["#ParkingLot.Document.CNH<", to_string(cnh), ">"])
    end
  end

  defimpl Phoenix.HTML.Safe do
    def to_iodata(cnh) do
      to_string(cnh)
    end
  end
end
