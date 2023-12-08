defmodule ParkingLot.Document do
  @moduledoc """
  Behaviour that defines a document digits-based.

  A document here can be defined as a sequence of digits that can a identifier number, such as a
  CPF, CNPJ, CNH, UPC, ISBN-10 or ISBN-13. Refer to [Check digit](https://en.wikipedia.org/wiki/Check_digit#Examples)
  for more information.
  """

  alias ParkingLot.Digits

  @typep digits :: Digits.t()
  @typep document :: struct
  @typep exception :: %{:reason => binary, optional(atom) => any}

  @doc "Creates a new document from the given digits."
  @callback new(digits) :: {:ok, document} | {:error, exception}

  @doc "Converts the given document into its digits representation."
  @callback to_digits(document) :: digits

  @doc "Converts the given document into its formatted string representation."
  @callback to_string(document) :: binary

  @doc "Calculates the weighted sum of the digits using the given weights."
  @spec weighted_sum(digits, weights :: Enumerable.t()) :: non_neg_integer
  def weighted_sum(digits, weights) do
    [digits, weights]
    |> Enum.zip()
    |> Enum.map(&Tuple.product/1)
    |> Enum.sum()
  end
end
